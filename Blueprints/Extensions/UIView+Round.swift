import UIKit

extension UIView {
    func round(withRadius radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
    }
}
