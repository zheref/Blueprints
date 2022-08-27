import UIKit
import RxSwift

class HomeViewController: BlueController, Loggable {
    
    static var logCategory: String { String(describing: HomeViewController.self) }
    
    // MARK: - UI
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var calendarCollectionViewLayout: UICollectionViewFlowLayout!
    
    // MARK: - Model
    var model = HomeViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        connect()
        model.lastEvent.onNext(.ready)
    }
    
    private func connect() {
        model.lastEvent
            .subscribe(onNext: { [weak self] event in
                switch event {
                case .starting:
                    break
                case .ready:
                    self?.setup()
                    self?.bind()
                }
            })
            .disposed(by: bag)
    }
    
    private func setup() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(userDidTapAdd))
        setupMiniCalendar()
    }
    
    private func bind() {}
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.briefingInHome {
            if let briefingController = segue.destination as? BriefingController {
                briefingController.model = model.forBriefing
                briefingController.model
                    .triggerNavigation
                    .subscribe { [weak self] (route, context) in
                        self?.performSegue(withIdentifier: route, sender: context)
                    }
                    .disposed(by: bag)
            }
            (segue.destination as? BriefingController)?.model = model.forBriefing
        } else if segue.identifier == K.Segue.homeToBlueprintDetail,
                    let lastBlueprint = sender as? Blueprint,
                    let blueprintController = segue.destination as? BlueprintController {
            blueprintController.model = BlueprintViewModel(blueprint: lastBlueprint)
            blueprintController.title = lastBlueprint.name
        } else if segue.identifier == K.Segue.homeToNewBlueprint {
            // TODO:
        }
    }
    
    // MARK: - User Actions
    
    @objc private func userDidTapAdd() {
        performSegue(withIdentifier: K.Segue.homeToNewBlueprint, sender: nil)
    }

}
