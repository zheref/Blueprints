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
        container.register { FirebaseAuthService() as IAuthService }
        container.register { CalendarDaysService() as DaysServiceProtocol }
        container.register { FirebaseStorageService() as StorageServiceProtocol }
        container.register { FirestoreBlueprintsService() as IBlueprintsService }
        container.register {
            FirestoreAssignmentsService(
                authService: $0,
                blueprintsService: $1,
                daysService: $2
            ) as IAssignmentsServive
        }
        container.register { FirestoreSuggestionsService() as SuggestionsServiceProtocol }
        return container
    }()
}
