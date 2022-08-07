//
//  DayCell.swift
//  Blueprints
//
//  Created by Sergio Lozano on 15/07/22.
//

import UIKit

class DayCell: UICollectionViewCell {
    
    static let identifier = "calendarDayCell"
    
    @IBOutlet weak var dateBoxView: UIView!
    @IBOutlet weak var dateNumberLabel: UILabel!
    
    @IBOutlet weak var actualDayLabel: UILabel!
    @IBOutlet weak var blueprintDayLabel: UILabel!
    
    var model: DayViewModel? {
        didSet { bind() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateBoxView.layer.cornerRadius = 8
        dateBoxView.layer.masksToBounds = true
    }
    
    func setSelected(_ selected: Bool) {
        if selected {
            contentView.round(withRadius: 12)
            contentView.backgroundColor = UIColor(named: "mainSelection")
        } else {
            contentView.round(withRadius: 0)
            contentView.backgroundColor = UIColor.clear
        }
    }
    
    private func bind() {
        guard let model = model else {
            return
        }
        
        dateBoxView?.backgroundColor = UIColor(named: model.hightlightColor)
        dateNumberLabel?.text = model.dayNumber
        actualDayLabel?.text = model.actualDayTitle
        blueprintDayLabel?.text = model.blueprintDayTitle
    }
    
}
