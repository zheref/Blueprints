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
    @IBOutlet weak var todayCaptionLabel: UILabel!
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
        bindPicture()
        bindRelativeName()
        bindMusic()
        
        printNameLabel.text = model.day.blueprint.name
        attributeLabel.text = model.day.blueprint.attribute.uppercased()
        
        transportLabel.text = model.day.blueprint.transport.emoji
        systemLabel.text = "🧭 \(model.day.blueprint.system.name)"
        
        bindColors()
        bindRatios()
    }
    
    private func bindRelativeName() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let captionText = model.day.date == BlueDate.today
            ? "TODAY:"
            : "\(formatter.string(from: model.day.date.toDate()!).uppercased()):"
        todayCaptionLabel.text = captionText
    }
    
    private func bindPicture() {
        let storageService = try! ServicesContainer.shared.resolve() as StorageServiceProtocol
        
        printImageView.image = nil
        if let imageUrl = model.day.blueprint.pictureUrl {
            storageService.downloadImage(named: imageUrl).subscribe(onSuccess: { [weak self] data in
                self?.printImageView.image = UIImage(data: data)
            }).disposed(by: bag)
        }
    }
    
    private func bindColors() {
        for i in 0..<model.day.blueprint.colors.count {
            colorViews[i].backgroundColor = UIColor(named: model.day.blueprint.colors[i].rawValue)
            colorViews[i].layer.borderWidth = 1
            colorViews[i].layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    private func bindMusic() {
        if let artists = model.day.blueprint.artists {
            musicLabel.text = "🎵 \(artists.joined(separator: ", "))"
        } else {
            musicLabel.text = "🎵 \(model.day.blueprint.music.name)"
        }
    }
    
    private func bindRatios() {
        let workHours = model.day.blueprint.work.reduce(0) { prev, work in
            prev + (work.minutes / 60)
        }
        
        workLabel.text = "👓 \(workHours)h"

        if let training = model.day.blueprint.training {
            let hours = training.minutes / 60
            trainLabel.text = "🏋️‍♂️ \(hours)h"
        }
    }

}
