import Foundation
import CoreGraphics

enum K {
    
    enum Copy {
        static let today = "Today"
        static let yesterday = "Yesterday"
        static let unassigned = "Unassigned"
    }
    
    enum Color {
        static let blueDay = "blueDayColor"
        static let redDay = "redDayColor"
        static let greenDay = "greenDayColor"
    }
    
    enum Segue {
        static let briefingInHome = "briefingInHome"
        static let homeToBlueprintDetail = "homeToBlueprintDetail"
        static let homeToNewBlueprint = "homeToNewBlueprint"
    }
    
    enum Measurement {
        static let carouselHeight: CGFloat = 170
        static let summaryHeight: CGFloat = 264
        static let blueprintPictureHeight: CGFloat = 230
    }
    
}
