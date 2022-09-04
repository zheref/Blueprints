import UIKit

class ColorsTrioView: UIStackView {
    
    static func buildRoundView(sized size: CGSize, withColor color: UIColor) -> UIView {
        let view = UIView(frame: CGRect(origin: .zero, size: size))
        view.backgroundColor = color
        let average = (size.width + size.height) / 2
        view.round(withRadius: average / 2)
        return view
    }
    
    convenience init(colors: [PrintColor]) {
        assert(colors.count >= 3)
        let commonSize = CGSize(width: 20, height: 20)
        
        self.init(arrangedSubviews: [
            Self.buildRoundView(
                sized: commonSize,
                withColor: colors[0].forUI
            ),
            Self.buildRoundView(
                sized: commonSize,
                withColor: colors[1].forUI
            ),
            Self.buildRoundView(
                sized: commonSize,
                withColor: colors[2].forUI
            )
        ])
        
        for subview in arrangedSubviews {
            subview.snp.makeConstraints { make in
                make.width.equalTo(commonSize.width)
                make.height.equalTo(commonSize.height)
            }
            
            subview.outline(withWidth: 1, andColor: .gray)
        }
        
        self.frame = CGRect(origin: .zero, size: CGSize(width: 70, height: 20))
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .equalSpacing
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
