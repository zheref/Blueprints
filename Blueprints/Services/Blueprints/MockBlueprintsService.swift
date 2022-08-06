import Foundation
import RxSwift

class MockBlueprintsService: IBlueprintsService {
    
    var publicOnes = [Blueprint.Mocked.kratos, Blueprint.Mocked.mark]
    var privateOnes = [Blueprint.Mocked.cap, Blueprint.Mocked.wayne]
    
    func fetchForContext(forUserId userId: String) -> Observable<GroupedBlueprints> {
        return Observable.of((
            public: [Blueprint.Mocked.kratos, Blueprint.Mocked.mark],
            private: [Blueprint.Mocked.cap, Blueprint.Mocked.wayne]
        ))
    }
    
    func fetchBriefingRows(forUserId userId: String) -> Observable<[BriefingRow]> {
        return Observable.of([
            ("First Row", .suggestions(blueprints: publicOnes, userId: nil)),
            ("Second Row", .suggestions(blueprints: privateOnes, userId: "test-user"))
        ])
    }
    
    
    func fetch(fromUser userId: String) -> Observable<[Blueprint]> {
        return Observable.of([Blueprint.Mocked.cap, Blueprint.Mocked.kratos])
    }
    
    func fetchAll() -> Observable<[Blueprint]> {
        return Observable.of([Blueprint.Mocked.mark, Blueprint.Mocked.wayne])
    }
    
}
