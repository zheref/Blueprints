import UIKit

class RatioBlock: UIStackView {
    
    var emojiLabel: UILabel {
        return arrangedSubviews[0] as! UILabel
    }
    
    var valueLabel: UILabel {
        return arrangedSubviews[1] as! UILabel
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(color: UIColor, emoji: String, value: String) {
        self.init(arrangedSubviews: [UILabel(), UILabel()])
        axis = .vertical
        distribution = .equalCentering
        alignment = .center
        backgroundColor = color
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        emojiLabel.font = UIFont.systemFont(ofSize: 24)
        valueLabel.font = UIFont(name: "Avenir", size: 13)
        
        configure(withEmoji: emoji, value: value)
    }
    
    func configure(withEmoji emoji: String, value: String) {
        emojiLabel.text = emoji
        valueLabel.text = value
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class RatioTrioCell: UITableViewCell {
    
    static let reuseIdentifier = "RatioTrioCell"
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            RatioBlock(color: K.Color.workPurpleDark, emoji: "❓", value: "?"),
            RatioBlock(color: K.Color.trainRedDark, emoji: "❓", value: "?"),
            RatioBlock(color: K.Color.chillBlueDark, emoji: "❓", value: "?")
        ])
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.snp.makeConstraints { make in
            make.height.equalTo(90)
            make.width.equalToSuperview()
        }
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().inset(12)
        }
        
        for subview in stackView.arrangedSubviews {
            subview.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.316)
                make.height.equalToSuperview()
            }
            subview.round(withRadius: 10)
        }
    }
    
    func configure(withRatios ratios: BlueRatios) {
        let ratiosArray = [
            ("👨🏻‍💻", ratios.work),
            ("🏃‍♂️", ratios.train),
            ("🧖‍♂️", ratios.chill)
        ]
        
        for (index, view) in stackView.arrangedSubviews.enumerated() {
            guard let ratioBlock = view as? RatioBlock else {
                continue
            }
            
            let ratio = ratiosArray[index]
            ratioBlock.configure(withEmoji: ratio.0, value: ratio.1)
        }
    }
    
}
