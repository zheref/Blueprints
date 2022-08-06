//
//  AuthServiceProtocol.swift
//  Blueprints
//
//  Created by Sergio Lozano on 18/07/22.
//

import Foundation
import RxSwift

protocol IAuthService {
    var currentUserId: String { get }
}
