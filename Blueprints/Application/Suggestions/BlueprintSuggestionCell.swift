import UIKit

class BlueprintSuggestionCell: UICollectionViewCell {
    static let reuseIdentifier = "blueprintSuggestionCell"
    
    @IBOutlet weak var blueprintImage: UIImageView!
    @IBOutlet weak var blueprintTitle: UILabel!
    
    var model: Blueprint! { didSet { bind() }}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        blueprintImage.image = UIImage(named: "blueprintPic")
        blueprintImage.layer.masksToBounds = true
        blueprintImage.layer.cornerRadius = 10
        
        if (model != nil) {
            bind()
        }
    }
    
    private func bind() {
        blueprintTitle?.text = model.name
    }
}
