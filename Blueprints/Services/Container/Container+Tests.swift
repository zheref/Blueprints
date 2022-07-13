import Dip

extension ServicesContainer {
    static let shared: DependencyContainer = {
        let container = DependencyContainer()
        container.register { MockAuthService() as AuthServiceProtocol }
        container.register { CalendarDaysService() as DaysServiceProtocol }
        container.register { MockBlueprintsService() as BlueprintsServiceProtocol }
        return container
    }()
}
