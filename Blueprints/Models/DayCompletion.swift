//
//  DayCompletion.swift
//  Blueprints
//
//  Created by Sergio Lozano on 15/07/22.
//

import Foundation

enum CompletionStatus {
    case fulfilled
    case halfway(detail: String)
    case failed(detail: String)
}

struct DayCompletion {
    let mainAttribute: CompletionStatus
    let workEnvironment: CompletionStatus
    let trainingWay: CompletionStatus
    let music: CompletionStatus
    let dressing: CompletionStatus
}
