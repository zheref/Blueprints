import UIKit

class SingleLineDetailCell: UITableViewCell {
    
    static let reuseIdentifier = "SingleLineDetailCell"
    
    var value: String? = nil
    
    let valueLabel: UILabel = {
        UILabel(frame: CGRect(
            origin: CGPoint.zero,
            size: CGSize(width: 100, height: 50)
        ))
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(valueLabel)
        
        valueLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        valueLabel.backgroundColor = UIColor.green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        valueLabel.text = value ?? "Hello new label"
    }

}
