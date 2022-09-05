import UIKit

class SingleLinePlainCell: UITableViewCell {
    
    static let reuseIdentifier = "SingleLinePlainCell"
    
    let contentLabel: UILabel = {
        let label = UILabel(frame: CGRect(
            origin: .zero,
            size: CGSize(width: 150, height: K.Measurement.regularRowHeight)
        ))
        
        label.font = UIFont(name: K.Font.avenirBook, size: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(13)
            make.trailing.equalToSuperview().inset(13)
        }
    }
    
}
