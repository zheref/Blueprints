import UIKit
import RxSwift

class SuggestionsBoxCell: UITableViewCell {
    
    // MARK: - Class Members
    
    static let reuseIdentifier = "suggestionsBoxCell"
    
    // MARK: - UI
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var printsCollection: UICollectionView!
    
    // MARK: - Reactive
    
    let bag = DisposeBag()
    var selectionDisposable: Disposable?
    
    var model: SuggestionsBoxViewModel! {
        didSet { bind() }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {}
    
    private func bind() {
        titleLabel.text = model.box.title
        
        printsCollection.dataSource = nil
        printsCollection.delegate = nil
        
        Observable.just(model.box.prints)
            .bind(to: printsCollection.rx
                .items(
                    cellIdentifier: BlueprintSuggestionCell.reuseIdentifier,
                    cellType: BlueprintSuggestionCell.self)
                )
            {
                $2.model = BlueprintSuggestionViewModel(blueprint: $1)
            }.disposed(by: bag)

        printsCollection.rx.setDelegate(self).disposed(by: bag)
        
        selectionDisposable?.dispose()
        
        selectionDisposable = printsCollection
            .rx
            .modelSelected(Blueprint.self)
            .subscribe(onNext: { [weak self] bprint in
                self?.model.printSelected.onNext(bprint)
            })
    }
    
    deinit {
        selectionDisposable?.dispose()
    }
    
}

// - MARK: Compliance

extension SuggestionsBoxCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 110, height: 128)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemAt indexPath: IndexPath,
                        point: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "", children: [
                UIAction(title: "Assign",
                         image: UIImage(systemName: "checkmark.circle"))
                    { [weak self] action in
                        if let print = self?.model.box.prints[indexPath.item] {
                            self?.model.assignClicked.onNext(print)
                        }
                    },
                UIAction(title: "Favorite",
                         image: UIImage(systemName: "star")) { [weak self] action in
                    if let print = self?.model.box.prints[indexPath.item] {
                        self?.model.favClicked.onNext(print)
                    }
                }
            ]) // UIMenu
        } // UIContextMenuConfiguration
    }

}
