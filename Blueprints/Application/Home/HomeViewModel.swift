import Foundation
import RxSwift

class HomeViewModel {
    
    var disposeBag = DisposeBag()
    
    var days: Observable<Days>
    
    let authService: AuthServiceProtocol
    let daysService: DaysServiceProtocol
    let blueprintsService: IBlueprintsService
    
    
    init(authService: AuthServiceProtocol = FirebaseAuthService(),
         daysService: DaysServiceProtocol = CalendarDaysService(),
         blueprintsService: IBlueprintsService = FirestoreBlueprintsService()) {
        let assignmentsService = try! ServicesContainer.shared.resolve() as AssignmentsServiceProtocol
        
        self.authService = authService
        self.daysService = daysService
        self.blueprintsService = blueprintsService
        // TODO: Make actual sequence later for actual day changes (app in foreground over mid-night)
        self.days = Observable.just(daysService.resolveAround(date: Date()))
        
        self.days.map { $0.compactMap { BlueDate.from(date: $0.date) } }.subscribe { [unowned self] dates in
            assignmentsService.fetch(forDates: dates, forUserId: self.authService.currentUserId).subscribe { assignments in
                print("Assignments", assignments)
            }.disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
    }
    
    lazy var forBriefing: BriefingViewModel = { BriefingViewModel() }()
    
}
