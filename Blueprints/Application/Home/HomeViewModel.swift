import Foundation
import RxSwift

class HomeViewModel {
    
    var bag = DisposeBag()
    
    var dates: Observable<[BlueDate]>
    var assignedDays = BehaviorSubject<[Day]>(value: [])
    
    let authService: IAuthService
    let daysService: DaysServiceProtocol
    let blueprintsService: IBlueprintsService
    
    init(authService: IAuthService = FirebaseAuthService(),
         daysService: DaysServiceProtocol = CalendarDaysService(),
         blueprintsService: IBlueprintsService = FirestoreBlueprintsService()) {
        let assignmentsService = try! ServicesContainer.shared.resolve() as IAssignmentsServive
        
        self.authService = authService
        self.daysService = daysService
        self.blueprintsService = blueprintsService
        // TODO: Make actual sequence later for actual day changes (app in foreground over mid-night)
        
        self.dates = daysService.resolveAround(date: Date()).map { $0.map { $0.date } }
        
        // TODO: Is this even valid or a good practice?
        self.dates.subscribe { [weak self] dates in
            guard let this = self else { return }
            assignmentsService.fetchAndMix(withDates: dates).subscribe(onNext: { [weak self] assignedDays in
                guard let this = self else { return }
                this.assignedDays.on(.next(assignedDays))
            }).disposed(by: this.bag)
        }.disposed(by: bag)
    }
    
    lazy var forBriefing: BriefingViewModel = {
        BriefingViewModel(assignedDays: self.assignedDays)
    }()
    
}
