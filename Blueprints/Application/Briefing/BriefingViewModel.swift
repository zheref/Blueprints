//
//  BriefingViewModel.swift
//  Blueprints
//
//  Created by Sergio Lozano on 18/07/22.
//

import Foundation
import RxSwift

enum BriefingRowType {
    case today(blueprint: Blueprint)
    case suggestions(blueprints: [Blueprint], userId: String)
}

typealias BriefingRow = (String, BriefingRowType)

class BriefingViewModel {
    
    var rows: Observable<[BriefingRow]>
    
    init() {
        let blueprintsService = try! ServicesContainer.shared.resolve() as BlueprintsServiceProtocol
        let suggestionsService = try! ServicesContainer.shared.resolve() as SuggestionsServiceProtocol
        let authService = try! ServicesContainer.shared.resolve() as AuthServiceProtocol
        
        self.rows = suggestionsService.fetch(forUser: authService.currentUserHandle)
            .map { $0.map { ($0.title, .suggestions(blueprints: $0.prints, userId: $0.forUser)) } }
    }
    
}
