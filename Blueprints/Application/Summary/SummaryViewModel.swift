import Foundation
import RxSwift

enum SummaryEvent {
    case ready
}

class SummaryViewModel: BlueViewModel {
    let day: BlueDay
    let event = PublishSubject<SummaryEvent>()

    init(blueday: BlueDay) {
        self.day = blueday
        super.init()
        event
            .subscribe(onNext: { print("SummaryViewModel [Event]: \($0)") })
            .disposed(by: bag)
    }
}
