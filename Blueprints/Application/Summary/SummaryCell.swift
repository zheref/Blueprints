//
//  TodayCell.swift
//  Blueprints
//
//  Created by Sergio Lozano on 18/07/22.
//

import UIKit
import RxSwift
import RxGesture

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
    @IBOutlet var clothesLabel: UILabel!
    @IBOutlet var notesLabel: UILabel!
    
    @IBOutlet weak var useCountContainer: UIView!
    @IBOutlet weak var useCountLabel: UILabel!
    
    @IBOutlet var pillViews: [UIView]!
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var trainLabel: UILabel!
    @IBOutlet weak var chillLabel: UILabel!
    
    // MARK: - Reactive
    
    let bag = DisposeBag()
    
    var model: SummaryViewModel! {
        didSet {
            connect()
            model.event.onNext(.ready)
        }
    }
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        model?.event.onNext(.ready)
    }
    
    private func connect() {
        model.event
            .distinctUntilChanged()
            .subscribe(onNext: self.received(event:))
            .disposed(by: bag)
    }
    
    private func received(event: SummaryEvent) {
        switch event {
        case .ready:
            bind()
            setup()
        case .userDidTapPrintImage:
            break
        }
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
        bindActions()
        
        bindPicture()
        bindRelativeName()
        bindMusic()
        
        printNameLabel.text = model.day.blueprint.name
        attributeLabel.text = model.day.blueprint.attribute.uppercased()
        transportLabel.text = model.day.blueprint.transport.emoji
        systemLabel.text = "🧭 \(model.day.blueprint.system.name)"
        useCountLabel.text = "\(model.day.printCount ?? 0)"
        
        bindColors()
        bindClothes()
        bindNotes()
        
        bindRatios()
    }
    
    var coverTapGestureDisposable: Disposable?
    
    private func bindActions() {
        coverTapGestureDisposable?.dispose()
        
        coverTapGestureDisposable = printImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.model.event.onNext(.userDidTapPrintImage)
            })
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
    
    private func bindClothes() {
        guard !model.day.blueprint.clothesStyles.isEmpty else {
            clothesLabel.text = ""
            return
        }
        
        clothesLabel.text = "🧣 \(model.day.blueprint.clothesStyles.map { $0.name }.joined(separator: ", "))"
    }
    
    private func bindNotes() {
        guard !model.day.blueprint.notes.isEmpty else {
            notesLabel.text = ""
            return
        }
        
        notesLabel.text = model.day.blueprint.notes.joined(separator: "\n")
    }
    
    private func bindRatios() {
        bindWork()
        bindTrain()
        bindChill()
    }
    
    private func bindWork() {
        let workHours = model.day.blueprint.work.reduce(0) { prev, work in
            prev + work.hours
        }
        
        workLabel.text = "👓 \(workHours.asReadable(withDecimals: 0))h"
    }
    
    private func bindTrain() {
        let trainHours = model.day.blueprint.train.reduce(0) { prev, train in
            prev + train.hours
        }
        
        trainLabel.text = "🏋️‍♂️ \(trainHours.asReadable(withDecimals: 0))h"
    }
    
    private func bindChill() {
        let chillHours = model.day.blueprint.chill.reduce(0) { prev, chill in
            prev + chill.hours
        }
        
        chillLabel.text = "🎮 \(chillHours.asReadable(withDecimals: 0))h"
    }
    
    deinit {
        coverTapGestureDisposable?.dispose()
    }

}
