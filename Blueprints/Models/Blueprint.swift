//
//  Blueprint.swift
//  Blueprints
//
//  Created by Sergio Lozano on 15/07/22.
//

import Foundation

struct WorkPlacement {
    let minutes: Int
    let environment: WorkEnvironment
    let mode: WorkMode
    let specifics: String?
}

struct TrainingPlacement {
    let minutes: Int
    let environment: TrainingEnvironment
    let ways: [TrainingWay]
    let specifics: String?
}

struct Blueprint: Equatable {
    let name: String
    
    let attribute: String
    let pictureUrl: String?
    
    let work: [WorkPlacement]
    let train: [TrainingPlacement]
    
//    let music: CompletionStatus
//    let dressing: CompletionStatus
    
    static func == (lhs: Blueprint, rhs: Blueprint) -> Bool {
        return lhs.name == rhs.name
    }
}
