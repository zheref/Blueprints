import UIKit

class ColorsTrioView: UIView {
    
    let colors: [PrintColor]
    
    init(frame: CGRect, colors: [PrintColor]) {
        self.colors = colors
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    private func setup() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width / 2, height: bounds.height))
        view.backgroundColor = UIColor(named: colors.first!.rawValue)
    }

}
