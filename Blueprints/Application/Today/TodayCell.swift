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
        useCountContainer.layer.cornerRadius = 8
        useCountContainer.layer.masksToBounds = true
    }
    
    private func bind() {
        
    }

}
