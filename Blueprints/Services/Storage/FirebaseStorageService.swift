import Foundation
import FirebaseStorage
import RxSwift

class FirebaseStorageService: StorageServiceProtocol, Loggable {
    
    static var logCategory: String { String(describing: FirebaseStorageService.self) }
    
    func downloadImage(named name: String) -> Single<Data> {
        let storage = try! firebaseInjector.resolve() as Storage
        
        return Single<Data>.create { single in
            // First try local
            
            let fileManager = FileManager.default
            let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let localImageUrl = documentDirectory.appendingPathComponent("blueprints/images/\(name)")
            
            if fileManager.fileExists(atPath: localImageUrl.path) {
                Self.logger.log("File [\(name)] exists. Using local version.")
                do {
                    let data = try Data(contentsOf: localImageUrl)
                    single(.success(data))
                } catch {
                    single(.failure(error))
                }
                
                return Disposables.create()
            } else {
                Self.logger.log("File [\(name)] not present locally. Downloading...")
                let reference = name.starts(with: "http") ? storage.reference(forURL: name) : storage.reference(withPath: name)
                
                let task = reference.write(toFile: localImageUrl) { localUrl, error in
                    guard let localUrl = localUrl else {
                        if let error = error {
                            Self.logger.error("Error(Downloading image with name \(name): \(error.localizedDescription)")
                            single(.failure(error))
                        } else {
                            single(.failure(
                                StorageServiceError.unknownStorageError(message: "Unknown error downloading image with name \(name)")
                            ))
                        }
                        
                        return
                    }
                    
                    do {
                        let data = try Data(contentsOf: localUrl)
                        single(.success(data))
                    } catch {
                        single(.failure(error))
                    }
                }
                
                return Disposables.create {
                    task.cancel()
                }
            }
        }
    }
    
}
