import UIKit
import RxSwift
import SnapKit

class PrintImageCell: UITableViewCell, Loggable {
    
    static var logCategory: String { String(describing: PrintImageCell.self) }
    static let reuseIdentifier = "PrintImageCell"
    
    // MARK: - UI Elements
    
    private let printImage: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let bag = DisposeBag()
    var imageUrlString: String? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let imageUrlString = imageUrlString {
            pullImage(withUrlString: imageUrlString)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        printImage.frame = contentView.bounds
        addSubview(printImage)
        
        printImage.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func pullImage(withUrlString urlString: String) {
        let storageService = try! ServicesContainer.shared.resolve() as StorageServiceProtocol

        storageService.downloadImage(named: urlString)
            .subscribe(onSuccess: { [weak self] imageData in
                self?.printImage.image = UIImage(data: imageData)
            }, onFailure: { error in
                Self.logger.error("Error downloading image \(error.localizedDescription)")
            })
            .disposed(by: bag)
    }

}
