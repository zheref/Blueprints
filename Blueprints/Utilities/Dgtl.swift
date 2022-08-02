import Foundation

class Dgtl {
    
    static let FACTOR: Int64 = 1024
    
    static func bytes(_ n: Int64) -> Int64 { n }
    
    static func kilo(_ n: Int64) -> Int64 { FACTOR * bytes(n) }
    
    static func mega(_ n: Int64) -> Int64 { FACTOR * kilo(n) }
    
    static func giga(_ n: Int64) -> Int64 { FACTOR * mega(n) }
    
    static func tera(_ n: Int64) -> Int64 { FACTOR * giga(n) }
    
    static func penta(_ n: Int64) -> Int64 { FACTOR * tera(n) }
    
}
