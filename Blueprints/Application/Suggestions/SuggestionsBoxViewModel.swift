import Foundation
import RxSwift

class SuggestionsBoxViewModel: BlueViewModel {
    
    let box: SuggestionsBox
    
    let assignClicked = PublishSubject<Blueprint>()
    let favClicked = PublishSubject<Blueprint>()
    let printSelected = PublishSubject<Blueprint>()
    
    init(box: SuggestionsBox) {
        self.box = box
    }
    
}
