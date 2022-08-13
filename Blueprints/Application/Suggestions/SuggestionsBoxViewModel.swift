import Foundation
import RxSwift

class SuggestionsBoxViewModel: BlueViewModel {
    
    let box: SuggestionsBox
    
    let printSelected = PublishSubject<Blueprint>()
    
    init(box: SuggestionsBox) {
        self.box = box
    }
    
}
