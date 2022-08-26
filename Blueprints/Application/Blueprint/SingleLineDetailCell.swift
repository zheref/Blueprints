import UIKit

class SingleLineDetailCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        frame.size = CGSize(width: bounds.width, height: 300)
        
        let simpleLabel = UILabel(frame: CGRect(
            origin: CGPoint.zero,
            size: CGSize(width: bounds.width / 2, height: bounds.height))
        )
        
        simpleLabel.text = "Hello new label"
        
        contentView.addSubview(simpleLabel)
    }

}
