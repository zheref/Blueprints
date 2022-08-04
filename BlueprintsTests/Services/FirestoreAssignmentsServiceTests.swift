//
//  FirestoreAssignmentsServiceTests.swift
//  BlueprintsTests
//
//  Created by Sergio Daniel on 8/4/22.
//

import Foundation
import XCTest
import FirebaseFirestore

@testable import Blueprints

class FirestoreAssignmentsServiceTests: XCTestCase {
    
    let mockedDocs: [RawDocument] = [
        ["date": "2022-08-04", "print": "users/zheref/blueprints/random1"]
    ]
    
    func testAssignmentsMap() {
        let firestore = try! FirebaseContainer.shared.resolve() as Firestore
        let mockedDocs: [RawDocument] = [
            [
                "date": "2022-08-04",
                "print": firestore.document("users/zheref/blueprints/random1")
            ],
            [
                "date": "2022-07-17",
                "print": firestore.document("users/zheref/blueprints/random2")
            ],
            [
                "date": "2021-09-18",
                "print": firestore.document("blueprints/random1")
            ]
        ]
        
        XCTAssertEqual(
            FirestoreAssignmentsService.assignmentsMap(from: mockedDocs),
            [
                "2022-08-04": "users/zheref/blueprints/random1",
                "2022-07-17": "users/zheref/blueprints/random2",
                "2021-09-18": "blueprints/random1"
            ]
        )
    }
    
}
