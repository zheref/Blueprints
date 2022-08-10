//
//  TodayCell.swift
//  Blueprints
//
//  Created by Sergio Lozano on 18/07/22.
//

import UIKit
import RxSwift

class SummaryCell: UITableViewCell {
    
    // MARK: - Class Members
    
    static let reuseIdentifier = "summaryCell"
    
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
    
    @IBOutlet var pillViews: [UIView]!
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var trainLabel: UILabel!
    @IBOutlet weak var chillLabel: UILabel!
    
    // MARK: - Reactive
    
    let bag = DisposeBag()
    
    var model: SummaryViewModel! {
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
        printImageView.contentMode = .scaleAspectFill
        
        for view in colorViews {
            view.round(withRadius: 10)
        }
        
        for view in pillViews {
            view.round(withRadius: 12)
        }
    }
    
    private func bind() {
        let storageService = try! ServicesContainer.shared.resolve() as StorageServiceProtocol
        
        printNameLabel.text = model.blueprint.name
        attributeLabel.text = model.blueprint.attribute.uppercased()
        
        transportLabel.text = model.blueprint.transport.emoji
        systemLabel.text = "🧭 \(model.blueprint.system.name)"
        
        if let artists = model.blueprint.artists {
            musicLabel.text = "🎵 \(artists.joined(separator: ", "))"
        } else {
            musicLabel.text = "🎵 \(model.blueprint.music.name)"
        }
        
        for i in 0..<model.blueprint.colors.count {
            colorViews[i].backgroundColor = UIColor(named: model.blueprint.colors[i].rawValue)
            colorViews[i].layer.borderWidth = 1
            colorViews[i].layer.borderColor = UIColor.gray.cgColor
        }
        
        if let imageUrl = model.blueprint.pictureUrl {
            storageService.downloadImage(named: imageUrl).subscribe(onSuccess: { [weak self] data in
                self?.printImageView.image = UIImage(data: data)
            }).disposed(by: bag)
        } else {
            printImageView.image = nil
        }
        
        let workHours = model.blueprint.work.reduce(0) { prev, work in
            prev + (work.minutes / 60)
        }
        
        workLabel.text = "👓 \(workHours)h"

        if let training = model.blueprint.training {
            let hours = training.minutes / 60
            trainLabel.text = "🏋️‍♂️ \(hours)h"
        }
    }

}
