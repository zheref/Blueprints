import Foundation
import FirebaseStorage
import RxSwift

class FirebaseStorageService: StorageServiceProtocol {
    
    func downloadImage(named name: String) -> Single<Data> {
        let storage = try! firebaseInjector.resolve() as Storage
        
        return Single<Data>.create { single in
            let reference = name.starts(with: "http") ? storage.reference(forURL: name) : storage.reference(withPath: name)
            
            let listener = reference.getData(maxSize: Dgtl.mega(2)) { data, error in
                guard let data = data else {
                    if let error = error {
                        print("Error(Downloading image with name \(name): \(error.localizedDescription)")
                        single(.failure(error))
                    } else {
                        single(.failure(
                            StorageServiceError.unknownStorageError(message: "Unknown error downloading image with name \(name)")
                        ))
                    }
                    
                    return
                }
                
                single(.success(data))
            }
            
            return Disposables.create {
                listener.cancel()
            }
        }
    }
    
}
