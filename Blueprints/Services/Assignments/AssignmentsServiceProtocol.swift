//
//  AssignmentsServiceProtocol.swift
//  Blueprints
//
//  Created by Sergio Lozano on 18/07/22.
//

import Foundation
import RxSwift

enum FirestoreAssignmentsServiceError: Error {
    case dateNotValid
}

protocol AssignmentsServiceProtocol: ServiceProtocol {
    func assign(bprint: Blueprint, toDate date: BlueDate, forUserId userId: String) -> Single<Void>
}
