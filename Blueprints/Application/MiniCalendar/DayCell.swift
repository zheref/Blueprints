//
//  DayCell.swift
//  Blueprints
//
//  Created by Sergio Lozano on 15/07/22.
//

import UIKit

class DayCell: UICollectionViewCell {

    // MARK: - Class Members
    
    static let identifier = "calendarDayCell"

    // MARK: - UI Elements
    
    @IBOutlet weak var dateBoxView: UIView!
    @IBOutlet weak var dateNumberLabel: UILabel!
    
    @IBOutlet weak var actualDayLabel: UILabel!
    @IBOutlet weak var blueprintDayLabel: UILabel!

    // MARK: - Reactive
    
    var model: DayViewModel? {
        didSet { bind() }
    }

    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateBoxView.round(withRadius: 8)
    }
    
    func setSelected(_ selected: Bool) {
        guard let model = model else { return }
        resolveDecoration(while: selected, today: model.day.date.isToday)
    }
    
    private func bind() {
        guard let model = model else { return }
        
        dateBoxView?.backgroundColor = UIColor(named: model.hightlightColor)
        dateNumberLabel?.text = model.dayNumber
        actualDayLabel?.text = model.actualDayTitle
        blueprintDayLabel?.text = model.blueprintDayTitle
        contentView.round(withRadius: 12)
        
        resolveDecoration(while: isSelected, today: model.day.date.isToday)
    }
    
    private func resolveDecoration(while selected: Bool, today: Bool) {
        if selected {
            actualDayLabel.font = UIFont(name: K.Font.avenirMedium, size: 12.0)
            blueprintDayLabel.font = UIFont(name: K.Font.avenirMedium, size: 12.0)
            if let model = model, model.day is RedDay {
                contentView.backgroundColor = UIColor.clear
                contentView.outline(withWidth: 3.0, andColor: K.Color.rogueSelection)
            } else {
                contentView.backgroundColor = K.Color.mainSelection
                contentView.outline(withWidth: 0)
            }
        } else if let model = model, model.day.date.isToday {
            actualDayLabel.font = UIFont(name: K.Font.avenirMedium, size: 12.0)
            blueprintDayLabel.font = UIFont(name: K.Font.avenirMedium, size: 12.0)
            contentView.backgroundColor = K.Color.rogueSelection
            contentView.outline(withWidth: 0)
        } else {
            actualDayLabel.font = UIFont(name: K.Font.avenirBook, size: 11.0)
            blueprintDayLabel.font = UIFont(name: K.Font.avenirBook, size: 11.0)
            contentView.backgroundColor = UIColor.clear
            contentView.outline(withWidth: 0)
        }
    }
    
}
