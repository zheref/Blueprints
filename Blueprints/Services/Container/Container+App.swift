//
//  Container+App.swift
//  Blueprints
//
//  Created by Sergio Lozano on 18/07/22.
//

import Foundation
import Dip

extension ServicesContainer {
    static let shared: DependencyContainer = {
        let container = DependencyContainer()
        container.register { FirebaseAuthService() as AuthServiceProtocol }
        container.register { CalendarDaysService() as DaysServiceProtocol }
        container.register { FirebaseStorageService() as StorageServiceProtocol }
        container.register { FirestoreBlueprintsService() as BlueprintsServiceProtocol }
        container.register { FirestoreAssignmentsService() as AssignmentsServiceProtocol }
        container.register { FirestoreSuggestionsService() as SuggestionsServiceProtocol }
        return container
    }()
}
