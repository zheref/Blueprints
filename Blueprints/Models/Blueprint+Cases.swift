//
//  Blueprint+Cases.swift
//  Blueprints
//
//  Created by Sergio Lozano on 15/07/22.
//

import Foundation

enum ClothesStyle: String {
    case cozy
    case sport
    case casual
    case fancy
    case classy
    
    var name: String {
        switch self {
        case .cozy:
            return "Cozy"
        case .sport:
            return "Sport"
        case .casual:
            return "Casual"
        case .fancy:
            return "Fancy"
        case .classy:
            return "Classy"
        }
    }
}

enum TransportationMethod: String {
    case bike
    case motorcycle
    case car
    case publicTransport
    case walking
    case any
    case plane
    case none
    
    var name: String {
        switch self {
        case .any:
            return "🏎 Any"
        case .walking:
            return "🚶‍♂️ Walking"
        case .bike:
            return "🚲 Bike"
        case .motorcycle:
            return "🏍 Motorcycle"
        case .car:
            return "🚙 Car"
        case .publicTransport:
            return "🚈 Public Transport"
        case .plane:
            return "✈️ Plane"
        case .none:
            return "🚫 None"
        }
    }
    
    var emoji: String {
        switch self {
        case .any:
            return "🏎"
        case .walking:
            return "🚶‍♂️"
        case .bike:
            return "🚲"
        case .motorcycle:
            return "🏍"
        case .car:
            return "🚙"
        case .publicTransport:
            return "🚈"
        case .plane:
            return "✈️"
        case .none:
            return "🚫"
        }
    }
}

enum SystemType: String {
    case deepWork
    case gtd
    case eatTheFrog
    case biologicalPrimetime
    case eisenhowerMatrix
    case pareto
    case free
    
    var name: String {
        switch self {
        case .free:
            return "Free"
        case .biologicalPrimetime:
            return "Biological Primetime"
        case .deepWork:
            return "Deep Work"
        case .eatTheFrog:
            return "Eat the Frog"
        case .eisenhowerMatrix:
            return "Eisenhower Matrix"
        case .gtd:
            return "Getting Things Done"
        case .pareto:
            return "Pareto Principle"
        }
    }
}

enum WorkMode: String {
    case corporate
    case personal
    case any
    
    var description: String {
        switch self {
        case .corporate:
            return "corporate"
        case .personal:
            return "personal"
        case .any:
            return "any"
        }
    }
}

enum WorkEnvironment: String {
    case unit
    case coworking
    case office
    case cafe
    case studio
    case any
    case none
    
    var description: String {
        switch self {
        case .unit:
            return "unit"
        case .coworking:
            return "coworking"
        case .office:
            return "Office"
        case .cafe:
            return "Cafe"
        case .studio:
            return "Studio"
        case .any:
            return "anywhere"
        case .none:
            return "nowhere"
        }
    }
}

enum TrainingWay: String {
    case elliptical
    case treadmill
    case bicycle
    case jogging
    case biceps
    case triceps
    case shoulders
    case chest
    case back
    case legs
    case core
    case small
    case fullBody
    case swimming
    case walking
}

enum TrainingEnvironment: String {
    case unit
    case gym
    case home
    case park
    case city
    case none
    
    var description: String {
        switch self {
        case .unit:
            return "unit"
        case .gym:
            return "Gym"
        case .home:
            return "Home"
        case .park:
            return "Park"
        case .city:
            return "city"
        case .none:
            return "nowhere"
        }
    }
}

enum ChillEnvironment: String {
    case readroom
    case pool
    case bedroom
    case lounge
    case outdoor
    case park
    case restaurant
    case mall
    case none
    
    var description: String {
        switch self {
        case .readroom:
            return "Reading room"
        case .pool:
            return "Pool"
        case .bedroom:
            return "bedroom"
        case .lounge:
            return "Lounge"
        case .outdoor:
            return "Outdoor"
        case .park:
            return "Park"
        case .restaurant:
            return "restaurant"
        case .mall:
            return "mall"
        case .none:
            return "nowhere"
        }
    }
    
}

enum ChillWay: String {
    case read
    case sleep
    case meditate
    case play
    case socialize
}

enum MusicType: String {
    case hipHop
    case pop
    case rocknRoll
    case rock
    case metal
    case punk
    case indie
    case jPop
    case jRock
    case orchestra
    case classical
    case soundtrack
    case electronic
    case trance
    case dance
    case house
    case salsa
    case artists
    case discover
    case any
    
    var name: String {
        switch self {
        case .any:
            return "Any"
        case .hipHop:
            return "Hip-Hop"
        case .pop:
            return "Pop"
        case .rocknRoll:
            return "Rock n Roll"
        case .rock:
            return "Rock"
        case .metal:
            return "Metal"
        case .indie:
            return "Indie"
        case .punk:
            return "Punk"
        case .jPop:
            return "J-Pop"
        case .jRock:
            return "J-Rock"
        case .orchestra:
            return "Orchestra"
        case .classical:
            return "Classical"
        case .soundtrack:
            return "Soundtrack"
        case .electronic:
            return "Electronic"
        case .trance:
            return "Trance"
        case .dance:
            return "Dance"
        case .house:
            return "House"
        case .salsa:
            return "Salsa"
        case .artists:
            return "Artists"
        case .discover:
            return "Discover"
        }
    }
}

enum PrintColor: String {
    case black
    case white
    case brown
    case yellow
    case green
    case red
    case blue
    case lightGray
    case darkGray
}

enum DressingType {
    
}
