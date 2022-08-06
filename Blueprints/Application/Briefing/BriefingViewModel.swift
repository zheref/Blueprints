import Foundation
import RxSwift

class BriefingViewModel {
    
    var rows: Observable<[BriefingRow]>
    var bag = DisposeBag()
    
    init() {
        let blueprintsService = try! ServicesContainer.shared.resolve() as IBlueprintsService
        let suggestionsService = try! ServicesContainer.shared.resolve() as SuggestionsServiceProtocol
        let authService = try! ServicesContainer.shared.resolve() as AuthServiceProtocol
        
        let blueprintsFetch = blueprintsService.fetchBriefingRows(forUserId: authService.currentUserId)
        let suggestionsFetch = suggestionsService.fetch(forUser: authService.currentUserId).map {
            $0.map {
                ($0.title, BriefingRowType.suggestions(blueprints: $0.prints, userId: $0.forUser))
            }
        }
        
        self.rows = Observable.combineLatest(blueprintsFetch, suggestionsFetch).map { $0 + $1 }
    }
    
    func userDidAssignToDate(bprint: Blueprint) {
        let assignmentsService = try! ServicesContainer.shared.resolve() as IAssignmentsServive
        let authService = try! ServicesContainer.shared.resolve() as AuthServiceProtocol
        
        assignmentsService
            .assign(bprint: bprint, toDate: BlueDate.today, forUserId: authService.currentUserId)
            .subscribe { _ in
                print("Succeding assigning")
            }.disposed(by: bag)

    }
    
    
    
}
