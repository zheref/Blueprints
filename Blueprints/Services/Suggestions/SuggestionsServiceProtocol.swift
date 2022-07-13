import RxSwift

protocol SuggestionsServiceProtocol: ServiceProtocol {
    func fetch(forUser userId: String) -> Observable<[SuggestionsBox]>
}
