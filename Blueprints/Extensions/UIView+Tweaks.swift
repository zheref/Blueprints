import UIKit

extension UIView {
    func round(withRadius radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
    }
    
    func outline(withWidth width: CGFloat, andColor color: UIColor? = nil) {
        layer.borderWidth = width
        
        if let color = color {
            layer.borderColor = color.cgColor
        }
    }
}
