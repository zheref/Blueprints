import Foundation
import RxSwift

class HomeViewModel {
    
    var disposeBag = DisposeBag()
    
    var days: Observable<Days>
    
    let authService: AuthServiceProtocol
    let daysService: DaysServiceProtocol
    let blueprintsService: BlueprintsServiceProtocol
    
    
    init(authService: AuthServiceProtocol = FirebaseAuthService(),
         daysService: DaysServiceProtocol = CalendarDaysService(),
         blueprintsService: BlueprintsServiceProtocol = FirestoreBlueprintsService()) {
        self.authService = authService
        self.daysService = daysService
        self.blueprintsService = blueprintsService
        // TODO: Make actual sequence later for actual day changes (app in foreground over mid-night)
        self.days = Observable.just(daysService.resolveAround(date: Date()))
    }
    
    lazy var forBriefing: BriefingViewModel = { BriefingViewModel() }()
    
}
