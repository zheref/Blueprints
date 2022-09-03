import UIKit
import RxSwift

class BlueViewModel: NSObject {
    let bag = DisposeBag()
}

class BlueController: UIViewController {
    let bag = DisposeBag()
}

class BlueTableController: UITableViewController {
    let bag = DisposeBag()
}

extension PrintColor {
    var forUI: UIColor {
        return UIColor(named: rawValue)!
    }
}
