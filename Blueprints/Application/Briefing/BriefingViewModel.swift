import Foundation
import RxSwift

class BriefingViewModel {
    
    var rows: Observable<[BriefingRow]>
    var bag = DisposeBag()
    
    init(assignedDays: Observable<[Day]>) {
        let blueprintsService = try! ServicesContainer.shared.resolve() as IBlueprintsService
        let suggestionsService = try! ServicesContainer.shared.resolve() as SuggestionsServiceProtocol
        let authService = try! ServicesContainer.shared.resolve() as IAuthService
        
        let blueprintsFetch = blueprintsService.fetchBriefingRows(forUserId: authService.currentUserId)
        let suggestionsFetch = suggestionsService.fetch(forUser: authService.currentUserId).map {
            $0.map {
                ($0.title, BriefingRowType.suggestions(blueprints: $0.prints, userId: $0.forUser))
            }
        }
        
        let suggestionsStream = Observable.combineLatest(blueprintsFetch, suggestionsFetch).map { $0 + $1 }
        let todayStream = assignedDays
            .map { $0.first(where: { $0.date == BlueDate.today }) }
            .map { day in
                guard let day = day as? BlueDay else {
                    return [BriefingRow]()
                }
                return [("Today", BriefingRowType.today(blueprint: day.blueprint))]
            }
        
        self.rows = Observable.combineLatest(todayStream, suggestionsStream).map { $0 + $1 }
    }
    
    func userDidAssignToDate(bprint: Blueprint) {
        let assignmentsService = try! ServicesContainer.shared.resolve() as IAssignmentsServive
        let authService = try! ServicesContainer.shared.resolve() as IAuthService
        
        assignmentsService
            .assign(bprint: bprint, toDate: BlueDate.today, forUserId: authService.currentUserId)
            .subscribe { _ in
                print("Succeding assigning")
            }.disposed(by: bag)

    }
    
    
    
}
