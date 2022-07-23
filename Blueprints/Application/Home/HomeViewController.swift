import UIKit
import RxSwift

class HomeViewController: BlueController {
    
    // MARK: - UI
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var calendarCollectionViewLayout: UICollectionViewFlowLayout!
    
    // MARK: - Model
    var model: HomeViewModel = HomeViewModel() // TODO: This is a mistake, look for a way to inject it from otside somehow. Maybe with Dip?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMiniCalendar()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.briefingInHome {
            (segue.destination as? BriefingController)?.model = model.forBriefing
        }
    }

}
