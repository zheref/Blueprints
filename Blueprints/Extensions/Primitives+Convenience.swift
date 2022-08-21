import Foundation

typealias RegularDict = [String: Any]

extension Double {
    func asReadable(withDecimals decimals: Int) -> String {
        String(format: "%.\(decimals)f", self)
    }
}
