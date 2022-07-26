import UIKit
import RxSwift

class SuggestionsCell: UITableViewCell {
    
    static let reuseIdentifier = "suggestionsCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var printsCollection: UICollectionView!
    
    let bag = DisposeBag()
    
    let assignClicked = PublishSubject<Blueprint>()
    let favClicked = PublishSubject<Blueprint>()
    
    var model: SuggestionsBox! {
        didSet { bind() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        printsCollection.delegate = self
    }
    
    private func bind() {
        titleLabel.text = model.title
        
        Observable.just(model.prints)
            .bind(to: printsCollection.rx
                .items(
                    cellIdentifier: BlueprintSuggestionCell.reuseIdentifier,
                    cellType: BlueprintSuggestionCell.self)
                )
            {
                $2.model = $1
            }.disposed(by: bag)
    }
    
}

extension SuggestionsCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 128)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let assignAction = UIAction(title: "Assign", image: nil) { [weak self] action in
                guard let print = self?.model.prints[indexPath.item] else { return }
                self?.assignClicked.onNext(print)
            }
            
            let favAction = UIAction(title: "Favorite", image: nil) { [weak self] action in
                guard let print = self?.model.prints[indexPath.item] else { return }
                self?.favClicked.onNext(print)
            }
            
            return UIMenu(title: "", children: [assignAction, favAction])
        }
    }
}
