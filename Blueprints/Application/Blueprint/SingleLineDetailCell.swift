import UIKit

class SingleLineDetailCell: UITableViewCell {
    
    static let reuseIdentifier = "SingleLineDetailCell"
    
    let captionLabel: UILabel = {
        let label = UILabel(frame: CGRect(
            origin: CGPoint.zero,
            size: CGSize(width: 100, height: K.Measurement.regularRowHeight)
        ))
        label.font = UIFont(name: K.Font.avenirBook, size: 12)
        label.textColor = K.Color.darkGray
        return label
    }()
    
    let valueLabel: UILabel = {
        UILabel(frame: CGRect(
            origin: CGPoint.zero,
            size: CGSize(width: 100, height: K.Measurement.regularRowHeight)
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
            make.height.equalTo(K.Measurement.regularRowHeight)
            make.width.equalToSuperview()
        }
        
        contentView.addSubview(captionLabel)
        captionLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(13.0)
        }
        
        contentView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(13.0)
        }
    }
    
    func configure(withCaption caption: String, withValue value: String?) {
        captionLabel.text = caption.uppercased()
        valueLabel.text = value ?? "Hello new label"
    }

}
