import Foundation

struct ZPath: Equatable {
    let parts: [String]
    
    static let SEPARATOR = "/"
    
    static func from(string: String) -> ZPath {
        if #available(iOS 16.0, *) {
            return ZPath(
                parts: string.split(separator: SEPARATOR).map { String($0) }
            )
        } else {
            return ZPath(
                parts: string.components(separatedBy: SEPARATOR)
            )
        }
    }
    
    var asString: String {
        return parts.joined(separator: Self.SEPARATOR)
    }
    
    static func ==(lhs: ZPath, rhs: ZPath) -> Bool {
        guard lhs.parts.count == rhs.parts.count else {
            return false
        }
        
        for n in 0...lhs.parts.count-1 {
            if rhs.parts[n] != lhs.parts[n] {
                return false
            }
        }
        
        return true
    }
}
