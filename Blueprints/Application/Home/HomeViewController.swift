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
        model.viewIsPrepared()
        setup()
    }
    
    private func setup() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(userDidTapAdd))
        setupMiniCalendar()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.briefingInHome {
            (segue.destination as? BriefingController)?.model = model.forBriefing
        }
    }
    
    // MARK: - User Actions
    
    @objc private func userDidTapAdd() {
        
    }

}
