import XCTest

class ZPathTests: XCTestCase {
    
    func testIn() {
        let str1 = "/this/is/a/path/for/test/purposes"
        XCTAssertEqual(
            ZPath.from(string: str1).parts,
            ["this", "is", "a", "path", "for", "test", "purposes"])
        
        let str2 = "this/is/another/path/for/test/purposes"
        XCTAssertEqual(
            ZPath.from(string: str2).parts,
            ["this", "is", "another", "path", "for", "test", "purposes"]
        )
        
        let str3 = "this/is/a/last/path/for/test/purposes/"
        XCTAssertEqual(
            ZPath.from(string: str3).parts,
            ["this", "is", "a", "last", "path", "for", "test", "purposes"]
        )
    }
    
    func testEquality() {
        let str1 = "/this/is/a/path/for/test/purposes"
        let str2 = "this/is/a/path/for/test/purposes"
        let str3 = "this/is/a/path/for/test/purposes/"
        let path = ZPath(parts: ["this", "is", "a", "path", "for", "test", "purposes"])
        
        XCTAssertTrue(ZPath.from(string: str1) == ZPath.from(string: str2))
        XCTAssertTrue(ZPath.from(string: str2) == ZPath.from(string: str3))
        XCTAssertTrue(ZPath.from(string: str1) == ZPath.from(string: str3))
        
        XCTAssertTrue(ZPath.from(string: str1) == path)
        XCTAssertTrue(ZPath.from(string: str2) == path)
        XCTAssertTrue(ZPath.from(string: str2) == path)
        
        XCTAssertEqual(
            ZPath.from(string: str1).asString,
            ZPath.from(string: str2).asString
        )
        XCTAssertEqual(
            ZPath.from(string: str2).asString,
            ZPath.from(string: str3).asString
        )
        XCTAssertEqual(
            ZPath.from(string: str1).asString,
            ZPath.from(string: str3).asString
        )
    }
    
}
