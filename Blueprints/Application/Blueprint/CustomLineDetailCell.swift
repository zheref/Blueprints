import UIKit

class CustomLineDetailCell: UITableViewCell {
    
    static let reuseIdentifier = "CustomLineDetailCell"
    
    let captionLabel: UILabel = {
        let label = UILabel(frame: CGRect(
            origin: CGPoint.zero,
            size: CGSize(width: 100, height: K.Measurement.regularRowHeight)
        ))
        label.font = UIFont(name: K.Font.avenirBook, size: 12)
        label.textColor = K.Color.darkGray
        return label
    }()
    
    private var customValueView: UIView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }
    
    func clearView() {
        customValueView?.removeFromSuperview()
    }
    
    func configure(withCaption caption: String, andCustomView customView: UIView) {
        captionLabel.text = caption.uppercased()
        
        customValueView?.removeFromSuperview()
        customValueView?.snp.removeConstraints()
        
        customValueView = customView
        contentView.addSubview(customValueView!)
        
        customValueView?.snp.makeConstraints({ make in
            make.width.equalTo(customView.bounds.width)
            make.height.equalTo(customView.bounds.height)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(13.0)
        })
    }
    
}
