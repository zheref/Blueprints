import RxSwift

enum BriefingRowType {
    case summary(blueprint: Blueprint)
    case suggestions(blueprints: [Blueprint], userId: String?)
}

typealias BriefingRow = (String, BriefingRowType)
typealias GroupedBlueprints = (public: [Blueprint], private: [Blueprint])

protocol IBlueprintsService: ServiceProtocol {
    func fetch(fromUser userId: String) -> Observable<[Blueprint]>
    func fetchAll() -> Observable<[Blueprint]>
    func fetchForContext(forUserId userId: String) -> Observable<GroupedBlueprints>
    func fetchBriefingRows(forUserId userId: String) -> Observable<[BriefingRow]>
}
