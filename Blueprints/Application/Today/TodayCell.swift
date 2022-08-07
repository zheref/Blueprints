//
//  TodayCell.swift
//  Blueprints
//
//  Created by Sergio Lozano on 18/07/22.
//

import UIKit
import RxSwift

class TodayCell: UITableViewCell {
    
    // MARK: - Class Members
    
    static let reuseIdentifier = "currentPrintCell"
    
    // MARK: - UI
    @IBOutlet weak var printNameLabel: UILabel!
    @IBOutlet weak var printImageView: UIImageView!
    @IBOutlet weak var attributeLabel: UILabel!
    @IBOutlet weak var transportLabel: UILabel!
    @IBOutlet weak var systemLabel: UILabel!
    @IBOutlet weak var useCountContainer: UIView!
    @IBOutlet weak var useCountLabel: UILabel!
    
    // MARK: - Reactive
    
    let bag = DisposeBag()
    
    var model: Blueprint! {
        didSet { bind() }
    }
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        useCountContainer.layer.cornerRadius = 10.5
        useCountContainer.clipsToBounds = true
        
        printImageView.clipsToBounds = true
        printImageView.layer.cornerRadius = 12
    }
    
    private func bind() {
        let storageService = try! ServicesContainer.shared.resolve() as StorageServiceProtocol
        
        printNameLabel.text = model.name
        attributeLabel.text = model.attribute
        
        if let imageUrl = model.pictureUrl {
            storageService.downloadImage(named: imageUrl).subscribe(onSuccess: { [weak self] data in
                self?.printImageView.image = UIImage(data: data)
            }).disposed(by: bag)
        } else {
            printImageView.image = nil
        }
    }

}
