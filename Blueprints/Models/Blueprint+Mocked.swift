import Foundation

extension Blueprint {
    enum Mocked {
        static var cap: Blueprint {
            Blueprint(name: "Cap-day", attribute: "Going to the office", pictureUrl: nil, work: [], train: [])
        }
        
        static var mark: Blueprint {
            Blueprint(name: "Mark-day", attribute: "First business day of the week", pictureUrl: nil, work: [], train: [])
        }
        
        static var kratos: Blueprint {
            Blueprint(name: "Kratos-day", attribute: "Second business day of the week", pictureUrl: nil, work: [], train: [])
        }
        
        static var wayne: Blueprint {
            Blueprint(name: "Wayne-day", attribute: "Deep focus day in-premises", pictureUrl: nil, work: [], train: [])
        }
    }
}
