import UIKit
import RxSwift

class BlueprintSuggestionCell: UICollectionViewCell {

    // MARK: - Class Members

    static let reuseIdentifier = "blueprintSuggestionCell"

    // MARK: - UI Elements
    
    @IBOutlet weak var blueprintImage: UIImageView!
    @IBOutlet weak var blueprintTitle: UILabel!

    // MARK: - Reactive
    
    var model: Blueprint! { didSet { bind() }}
    let bag = DisposeBag()

    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        blueprintImage.image = nil
        blueprintImage.layer.masksToBounds = true
        blueprintImage.layer.cornerRadius = 10
        blueprintImage.contentMode = .scaleAspectFill
        
        if model != nil { bind() }
    }
    
    private func bind() {
        blueprintTitle?.text = model.name
        blueprintImage.image = nil
        
        if let picUrl = model.pictureUrl {
            pullImage(withUrlString: picUrl)
        }
    }
    
    private func pullImage(withUrlString urlString: String) {
        let storageService = try! ServicesContainer.shared.resolve() as StorageServiceProtocol
        
        storageService.downloadImage(named: urlString)
            .subscribe(onSuccess: { [weak self] imageData in
                self?.blueprintImage.image = UIImage(data: imageData)
            }, onFailure: { error in
                print("Error downloading image", error.localizedDescription)
            })
            .disposed(by: bag)
    }
}
