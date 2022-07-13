import UIKit
import RxSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var calendarCollectionViewLayout: UICollectionViewFlowLayout!
    
    var model: HomeViewModel = HomeViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMiniCalendar()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.briefingInHome {
            (segue.destination as? BriefingController)?.model = model.forBriefing
        }
    }

}
