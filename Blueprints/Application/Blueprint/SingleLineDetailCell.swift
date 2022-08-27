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
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setup() {
        contentView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalToSuperview()
        }
        
        contentView.addSubview(valueLabel)
        valueLabel.backgroundColor = UIColor.green
        valueLabel.text = "Hola Label"
        
        valueLabel.snp.makeConstraints { make in
            make.height.equalTo(50.0)
            make.width.equalToSuperview()
//            make.edges.equalTo(contentView)
        }
    }
    
    func configure(withValue value: String?) {
        self.value = value
        valueLabel.text = value ?? "Hello new label"
    }

}
