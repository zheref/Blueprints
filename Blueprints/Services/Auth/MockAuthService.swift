//
//  MockAuthService.swift
//  Blueprints
//
//  Created by Sergio Lozano on 18/07/22.
//

import Foundation

import Foundation
import RxSwift

class MockAuthService: AuthServiceProtocol {
    
    var currentUserHandle: Observable<String> {
        // TODO: Implement actual authentication mechanism
        return Observable<String>.just("mock-user")
    }
    
}
