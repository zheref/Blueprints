import Foundation
import RxSwift

enum StorageServiceError: Error {
    case unknownStorageError(message: String)
}

protocol StorageServiceProtocol: ServiceProtocol {
    func downloadImage(named name: String) -> Single<Data>
}
