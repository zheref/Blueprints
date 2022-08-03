//
//  FirestoreAssignmentsService.swift
//  Blueprints
//
//  Created by Sergio Lozano on 18/07/22.
//

import Foundation
import RxSwift
import FirebaseFirestore

class FirestoreAssignmentsService: AssignmentsServiceProtocol {
    
    static let collectionName = "assignments"
    
    func assign(bprint: Blueprint, toDate date: BlueDate, forUserId userId: String) -> Single<Void> {
        let firestore = try! firebaseInjector.resolve() as Firestore
        
        guard let dateString = date.toString() else {
            return Single.error(FirestoreAssignmentsServiceError.dateNotValid)
        }
        
        guard let printID = bprint.documentID else {
            return Single.error(BlueError.noIdentifier)
        }
        
        let assignmentData: [String: Any] = [
            "date": dateString,
            "print": bprint.privacy == .privately
                ? firestore.document("/users/\(userId)/blueprints/\(printID)")
                : firestore.document("/blueprints/\(printID)")
        ]
        
        return Single.create { [assignmentData, userId] trigger in
            firestore
                .document("/users/\(userId)")
                .collection(Self.collectionName)
                .document(dateString)
                .setData(assignmentData) { error in
                    if let error = error {
                        print("Error assigning day:", error.localizedDescription)
                        trigger(.failure(error))
                    }
                    
                    trigger(.success(Void()))
                }
            
            return Disposables.create { }
        }
    }
    
}
