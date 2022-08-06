//
//  AssignmentsServiceProtocol.swift
//  Blueprints
//
//  Created by Sergio Lozano on 18/07/22.
//

import Foundation
import RxSwift

typealias AssignmentsMap = [String: String]

struct Assignment {
    let date: BlueDate
    let print: Blueprint
}

enum AssignmentsServiceError: Error {
    case dateNotValid
    case unknownFetchError
}

protocol IAssignmentsServive: ServiceProtocol {
    func assign(bprint: Blueprint, toDate date: BlueDate, forUserId userId: String) -> Single<Void>
    func fetch(forDates dates: [BlueDate], forUserId userId: String) -> Observable<AssignmentsMap>
    func fetchAndParse(forDates dates: [BlueDate]) -> Observable<[Assignment]>
    func fetchAndMix(withDates dates: [BlueDate]) -> Observable<[Day]>
}
