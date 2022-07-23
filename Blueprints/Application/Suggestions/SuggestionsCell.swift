import UIKit
import RxSwift

class SuggestionsCell: UITableViewCell {
    
    static let reuseIdentifier = "suggestionsCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var printsCollection: UICollectionView!
    
    let bag = DisposeBag()
    
    var model: SuggestionsBox! {
        didSet { bind() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        printsCollection.delegate = self
//        printsCollection.dataSource = self
    }
    
    private func bind() {
        titleLabel.text = model.title
//        printsCollection.reloadData()
        
        Observable.just(model.prints)
            .bind(to: printsCollection.rx.items(
                cellIdentifier: BlueprintSuggestionCell.reuseIdentifier,
                cellType: BlueprintSuggestionCell.self)) {
                $2.model = $1
            }.disposed(by: bag)
    }
    
}

extension SuggestionsCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BlueprintSuggestionCell.reuseIdentifier, for: indexPath) as? BlueprintSuggestionCell {
            cell.model = model.prints[indexPath.item]
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.prints.count ?? 0
    }
}

extension SuggestionsCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 128)
    }
}
