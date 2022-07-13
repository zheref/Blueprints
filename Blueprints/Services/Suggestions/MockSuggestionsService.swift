import RxSwift

class MockSuggestionsService: SuggestionsServiceProtocol {
    func fetch(forUser userId: String) -> Observable<[SuggestionsBox]> {
        return Observable<[SuggestionsBox]>.just([
            SuggestionsBox.Mocked.daysLikeToday
        ])
    }
}
