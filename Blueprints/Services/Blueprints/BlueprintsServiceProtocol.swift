//
//  BlueprintsServiceProtocol.swift
//  Blueprints
//
//  Created by Sergio Lozano on 18/07/22.
//

import RxSwift

protocol BlueprintsServiceProtocol: ServiceProtocol {
    
    func fetch(fromUser userId: String) -> Observable<[Blueprint]>
    func fetchAll() -> Observable<[Blueprint]>
    
}
