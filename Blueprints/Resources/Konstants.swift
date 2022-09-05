import Foundation
import UIKit

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
        
        static let mainSelection = UIColor(named: "mainSelection")
        static let rogueSelection = UIColor(named: "rogueSelection")
        
        static let darkGray = UIColor(named: "darkGray")
        
        static let workPurple = UIColor(named: "workPurple")!
        static let chillBlue = UIColor(named: "chillBlue")!
        static let trainRed = UIColor(named: "trainRed")!
        
        static let workPurpleDark = UIColor(named: "workPurpleDark")!
        static let chillBlueDark = UIColor(named: "chillBlueDark")!
        static let trainRedDark = UIColor(named: "trainRedDark")!
    }
    
    enum Font {
        static let avenirMedium = "Avenir-Medium"
        static let avenirBook = "Avenir-Book"
        static let avenirOblique = "Avenir-Oblique"
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
        
        static let regularRowHeight: CGFloat = 43.5
    }
    
}
