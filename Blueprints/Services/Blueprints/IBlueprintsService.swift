import RxSwift

protocol IBlueprintsService: ServiceProtocol {
    
    func fetch(fromUser userId: String) -> Observable<[Blueprint]>
    func fetchAll() -> Observable<[Blueprint]>
    
}
