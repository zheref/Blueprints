import Foundation
import RxSwift

enum HomeViewEvent {
    case starting
    case ready
}

class HomeViewModel: Loggable {
    
    static var logCategory: String { String(describing: HomeViewModel.self) }

    var bag = DisposeBag()

    // MARK: - Observables
    var dates: Observable<[BlueDate]>
    var selectedDay: Observable<Day>
    
    // MARK: - Subjects
    
    // MARK: Events
    let lastEvent = BehaviorSubject<HomeViewEvent>(value: .starting)
    var unassignClicked = PublishSubject<BlueDate>()
    var pinClicked = PublishSubject<BlueDate>()
    var selectDateAtIndex = PublishSubject<IndexPath>()
    
    var days = BehaviorSubject<[Day]>(value: [])
    var calendarDays: Observable<[Day]>
    
    var lastSelectedBlueprint: Blueprint?
    
    init() {
        let assignmentsService = try! ServicesContainer.shared.resolve() as IAssignmentsServive
        let daysService = try! ServicesContainer.shared.resolve() as DaysServiceProtocol

        // TODO: Make actual sequence later for actual day changes (app in foreground over mid-night)
        dates = daysService.resolveAround(date: Date()).map { $0.map { $0.date } }
        
        selectedDay = selectDateAtIndex
            .withLatestFrom(days) { ($0, $1) }
            .map { path, days in
                days[path.item]
            }
        
        calendarDays = days
            .withLatestFrom(dates) { ($0, $1) }
            .map({ days, dates in
                days.filter { dates.contains($0.date) }
            })
        
        lastEvent.subscribe(onNext: { [weak self] event in
            switch event {
            case .starting:
                break
            case .ready:
                self?.viewIsPrepared()
            }
        }).disposed(by: bag)
        
        // TODO: Is this even valid or a good practice?
        dates.subscribe(onNext: { [weak self] dates in
            guard let this = self else { return }
            assignmentsService.fetchRelevantAssignments(forDates: dates, whileToday: BlueDate.today)
                .subscribe(onNext: { [weak self] completeDays in
                    guard let this = self else { return }
                    this.days.on(.next(completeDays))
                })
                .disposed(by: this.bag)
        }).disposed(by: bag)
    }
    
    lazy var forBriefing: BriefingViewModel = {
        BriefingViewModel(
            assignedDays: self.days,
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
                Self.logger.info("Succeeded unassigning date \(date.toString() ?? "DATE NOT PARSEABLE").")
            }.disposed(by: bag)
    }
    
}
