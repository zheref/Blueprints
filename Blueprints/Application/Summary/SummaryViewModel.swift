import Foundation
import RxSwift

enum SummaryEvent {
    case ready
    case userDidTapPrintImage
}

class SummaryViewModel: BlueViewModel {
    let day: BlueDay
    let event = PublishSubject<SummaryEvent>()

    init(blueday: BlueDay) {
        self.day = blueday
        super.init()
        event
            .subscribe(onNext: handle(event:))
            .disposed(by: bag)
    }
    
    private func handle(event: SummaryEvent) {
        print("SummaryViewModel [Event]: \(event)")
        
    }
}
