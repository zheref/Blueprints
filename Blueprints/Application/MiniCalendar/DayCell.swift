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
        if selected {
            if let model = model, model.day is RedDay {
                contentView.backgroundColor = UIColor.clear
                contentView.outline(withWidth: 3.0, andColor: UIColor(named: "rogueSelection"))
            } else {
                contentView.backgroundColor = UIColor(named: "mainSelection")
                contentView.outline(withWidth: 0)
            }
        } else if let model = model, model.day.date.isToday {
            contentView.backgroundColor = UIColor(named: "rogueSelection")
            contentView.outline(withWidth: 0)
        } else {
            contentView.backgroundColor = UIColor.clear
            contentView.outline(withWidth: 0)
        }
    }
    
    private func bind() {
        guard let model = model else { return }
        
        dateBoxView?.backgroundColor = UIColor(named: model.hightlightColor)
        dateNumberLabel?.text = model.dayNumber
        actualDayLabel?.text = model.actualDayTitle
        blueprintDayLabel?.text = model.blueprintDayTitle
        contentView.round(withRadius: 12)
        
        if model.day.date.isToday {
            actualDayLabel.font = UIFont(name: "Avenir-Medium", size: 12.0)
            blueprintDayLabel.font = UIFont(name: "Avenir-Medium", size: 12.0)
            contentView.backgroundColor = UIColor(named: "rogueSelection")
        } else {
            blueprintDayLabel.font = UIFont(name: "Avenir-Book", size: 11.0)
        }
    }
    
}
