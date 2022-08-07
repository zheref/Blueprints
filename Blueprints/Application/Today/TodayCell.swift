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
    @IBOutlet weak var musicLabel: UILabel!
    @IBOutlet var colorViews: [UIView]!
    
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
        useCountContainer.round(withRadius: 10.5)
        printImageView.round(withRadius: 12)
        
        for view in colorViews {
            view.round(withRadius: 10)
        }
    }
    
    private func bind() {
        let storageService = try! ServicesContainer.shared.resolve() as StorageServiceProtocol
        
        printNameLabel.text = model.name
        attributeLabel.text = model.attribute
        
        transportLabel.text = "🛣 → \(model.transport.name)"
        systemLabel.text = "🧭 \(model.system.name)"
        
        if let artists = model.artists {
            musicLabel.text = "🎵 \(artists.joined(separator: ", "))"
        } else {
            musicLabel.text = "🎵 \(model.music.name)"
        }
        
        for i in 0..<model.colors.count {
            colorViews[i].backgroundColor = UIColor(named: model.colors[i].rawValue)
        }
        
        if let imageUrl = model.pictureUrl {
            storageService.downloadImage(named: imageUrl).subscribe(onSuccess: { [weak self] data in
                self?.printImageView.image = UIImage(data: data)
            }).disposed(by: bag)
        } else {
            printImageView.image = nil
        }
    }

}
