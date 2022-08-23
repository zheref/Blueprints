import Foundation
import RxSwift

class HomeViewModel {

    var bag = DisposeBag()

    // MARK: - Observables
    var dates: Observable<[BlueDate]>
    var selectedDay: Observable<Day>
    
    // MARK: - Subjects
    
    // MARK: Events
    var unassignClicked = PublishSubject<BlueDate>()
    var pinClicked = PublishSubject<BlueDate>()
    var selectDateAtIndex = PublishSubject<IndexPath>()
    
    // MARK: Computed observables?
    var assignedDays = BehaviorSubject<[Day]>(value: [])
    
    var lastSelectedBlueprint: Blueprint?
    
    init() {
        let assignmentsService = try! ServicesContainer.shared.resolve() as IAssignmentsServive
        let daysService = try! ServicesContainer.shared.resolve() as DaysServiceProtocol

        // TODO: Make actual sequence later for actual day changes (app in foreground over mid-night)
        dates = daysService.resolveAround(date: Date()).map { $0.map { $0.date } }
        
        selectedDay = selectDateAtIndex
            .withLatestFrom(assignedDays) { ($0, $1) }
            .map { path, days in
                days[path.item]
            }
        
        // TODO: Is this even valid or a good practice?
        dates.subscribe(onNext: { [weak self] dates in
            guard let this = self else { return }
            assignmentsService.fetchRelevantAssignments(forDates: dates, whileToday: BlueDate.today)
                .subscribe(onNext: { [weak self] assignedDays in
                    guard let this = self else { return }
                    this.assignedDays.on(.next(assignedDays))
                })
                .disposed(by: this.bag)
        }).disposed(by: bag)
    }
    
    lazy var forBriefing: BriefingViewModel = {
        BriefingViewModel(
            assignedDays: self.assignedDays,
            selectedDay: self.selectedDay
        )
    }()

    func viewIsPrepared() {
        unassignClicked
            .subscribe(onNext: userDidUnassign)
            .disposed(by: bag)
    }

    private func userDidUnassign(date: BlueDate) {
        let assignmentsService = try! ServicesContainer.shared.resolve() as IAssignmentsServive
        let authService = try! ServicesContainer.shared.resolve() as IAuthService

        assignmentsService
            .unassign(date: date, forUserId: authService.currentUserId)
            .subscribe { event in
                print("Succeeded unassigning")
            }.disposed(by: bag)
    }
    
}
