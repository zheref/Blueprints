//
//  AuthServiceProtocol.swift
//  Blueprints
//
//  Created by Sergio Lozano on 18/07/22.
//

import Foundation
import RxSwift

protocol AuthServiceProtocol {
    var currentUserId: String { get }
}
