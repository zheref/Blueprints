import Foundation
import RxSwift

class MockBlueprintsService: IBlueprintsService {
    
    func fetch(fromUser userId: String) -> Observable<[Blueprint]> {
        return Observable.of([Blueprint.Mocked.cap, Blueprint.Mocked.kratos])
    }
    
    func fetchAll() -> Observable<[Blueprint]> {
        return Observable.of([Blueprint.Mocked.mark, Blueprint.Mocked.wayne])
    }
    
}
