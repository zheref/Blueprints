import Foundation
import RxSwift

enum BriefingRowType {
    case today(blueprint: Blueprint)
    case suggestions(blueprints: [Blueprint], userId: String?)
}

typealias BriefingRow = (String, BriefingRowType)

class BriefingViewModel {
    
    var rows: Observable<[BriefingRow]>
    var bag = DisposeBag()
    
    init() {
        let blueprintsService = try! ServicesContainer.shared.resolve() as IBlueprintsService
        let suggestionsService = try! ServicesContainer.shared.resolve() as SuggestionsServiceProtocol
        let authService = try! ServicesContainer.shared.resolve() as AuthServiceProtocol
        
        let blueprintsFetch = Observable.combineLatest(
            blueprintsService.fetchAll(),
            blueprintsService.fetch(fromUser: authService.currentUserId)
        ).map {
            Array<BriefingRow>([
                ("My blueprints", .suggestions(blueprints: $1, userId: authService.currentUserId)),
                ("All blueprints", .suggestions(blueprints: $0, userId: nil))
            ])
        }
        
        let suggestionsFetch = suggestionsService.fetch(forUser: authService.currentUserId).map {
            $0.map {
                ($0.title, BriefingRowType.suggestions(blueprints: $0.prints, userId: $0.forUser))
            }
        }
        
        self.rows = Observable.combineLatest(blueprintsFetch, suggestionsFetch).map { $0 + $1 }
    }
    
    func userDidAssignToDate(bprint: Blueprint) {
        let assignmentsService = try! ServicesContainer.shared.resolve() as AssignmentsServiceProtocol
        let authService = try! ServicesContainer.shared.resolve() as AuthServiceProtocol
        
        guard let blueToday = BlueDate.from(date: Date()) else {
            print("Error transpolating BlueDate from today")
            return
        }
        
        assignmentsService
            .assign(bprint: bprint, toDate: blueToday, forUserId: authService.currentUserId)
            .subscribe { _ in
                print("Succeding assigning")
            }.disposed(by: bag)

    }
    
    
    
}
