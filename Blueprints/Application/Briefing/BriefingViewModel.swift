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
    case suggestions(blueprints: [Blueprint], userId: String?)
}

typealias BriefingRow = (String, BriefingRowType)

class BriefingViewModel {
    
    var rows: Observable<[BriefingRow]>
    
    init() {
        let userId = "zheref"
        
        let blueprintsService = try! ServicesContainer.shared.resolve() as BlueprintsServiceProtocol
        let suggestionsService = try! ServicesContainer.shared.resolve() as SuggestionsServiceProtocol
        let authService = try! ServicesContainer.shared.resolve() as AuthServiceProtocol
        
        let publicFetch = blueprintsService.fetchAll()
        let privateFetch = blueprintsService.fetch(fromUser: userId)
        
        let blueprintsFetch = Observable.combineLatest(publicFetch, privateFetch).map {
            [
                ("My blueprints", BriefingRowType.suggestions(blueprints: $1, userId: userId)),
                ("All blueprints", BriefingRowType.suggestions(blueprints: $0, userId: nil))
            ]
        }
        
        let suggestionsFetch = suggestionsService.fetch(forUser: authService.currentUserHandle).map {
            $0.map {
                ($0.title, BriefingRowType.suggestions(blueprints: $0.prints, userId: $0.forUser))
            }
        }
        
        self.rows = Observable.combineLatest(blueprintsFetch, suggestionsFetch).map {
            $0 + $1
        }
    }
    
}
