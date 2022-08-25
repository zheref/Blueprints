import Foundation
import RxSwift

class BriefingViewModel: BlueViewModel {

    // MARK: Reactive
    var rows: Observable<[BriefingRow]>
    var selectedDay: Observable<Day>

    // MARK: Stateful
    var selectedDate: BlueDate?
    var isSummaryOpen = false
    
    // MARK: Actions Stream
    var triggerNavigation = PublishSubject<(route: String, context: Any)>()

    // MARK: - Computed observables

    var isSummaryOpenStream: Observable<Bool> {
        rows.map { rows in
            guard let first = rows.first else {
                return false
            }

            switch first.1 {
            case .summary(_):
                return true
            case .suggestions(_, _):
                return false
            }
        }
    }

    // MARK: - Lifecycle
    
    init(assignedDays: Observable<[Day]>, selectedDay: Observable<Day>) {
        let blueprintsService = try! ServicesContainer.shared.resolve() as IBlueprintsService
        let suggestionsService = try! ServicesContainer.shared.resolve() as SuggestionsServiceProtocol
        let authService = try! ServicesContainer.shared.resolve() as IAuthService
        
        let blueprintsFetch = blueprintsService.fetchBriefingRows(forUserId: authService.currentUserId)
        let suggestionsFetch = suggestionsService.fetch(forUser: authService.currentUserId).map {
            $0.map {
                ($0.title, BriefingRowType.suggestions(blueprints: $0.prints, userId: $0.forUser))
            }
        }
        
        let suggestionsStream = Observable
            .combineLatest(blueprintsFetch, suggestionsFetch)
            .map { $0 + $1 }
        
        let todayStream = assignedDays
            .compactMap { $0.first(where: { $0.date == BlueDate.today }) }
        
        let summaryStream = Observable
            .combineLatest(
                todayStream,
                Observable.merge(todayStream, selectedDay)
            )
            .map { (today, selection) -> Day in
                if selection.date == BlueDate.today {
                    return today
                }
                
                if let blueSelection = selection as? BlueDay {
                    return blueSelection
                } else {
                    return today
                }
            }
        
        let summaryBriefing = summaryStream
            .withLatestFrom(assignedDays) { (day, assignedDays) -> Day in
                guard var day = day as? BlueDay else { return day }
                
                let appearances = assignedDays.filter {
                    guard let assignedDay = $0 as? BlueDay else {
                        return false
                    }
                    
                    return day.blueprint == assignedDay.blueprint
                }.count
                
                day.printCount = appearances
                return day
            }
            .map { day -> [BriefingRow] in
                guard let day = day as? BlueDay else {
                    return [BriefingRow]()
                }
                return [("Summary", BriefingRowType.summary(blueday: day))]
            }
        
        rows = Observable.combineLatest(summaryBriefing, suggestionsStream).map { $0 + $1 }
        
        self.selectedDay = selectedDay
    }

    func viewIsPrepared() {
        isSummaryOpenStream.subscribe(onNext: { [weak self] in
            self?.isSummaryOpen = $0
        }).disposed(by: bag)

        selectedDay.subscribe(onNext: { [weak self] day in
            self?.selectedDate = day.date
        }).disposed(by: bag)
    }

    // MARK: - User Actions
    
    func userDidSelect(bprint: Blueprint) {
        print("[Zdebug] User did select bprint w/name \(bprint.name)")
        triggerNavigation.onNext((
            route: K.Segue.homeToBlueprintDetail,
            context: bprint
        ))
    }
    
    func userDidAssignToDate(bprint: Blueprint) {
        let assignmentsService = try! ServicesContainer.shared.resolve() as IAssignmentsServive
        let authService = try! ServicesContainer.shared.resolve() as IAuthService
        
        assignmentsService
            .assign(bprint: bprint,
                    toDate: selectedDate ?? BlueDate.today,
                    forUserId: authService.currentUserId)
            .subscribe { _ in
                print("Succeding assigning")
            }.disposed(by: bag)
    }
    
    
    
}
