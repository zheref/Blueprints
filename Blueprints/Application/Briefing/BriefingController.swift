//
//  BriefingController.swift
//  Blueprints
//
//  Created by Sergio Lozano on 18/07/22.
//

import UIKit
import RxSwift
import RxCocoa

class BriefingController: BlueController {
    
    // MARK: - UI
    @IBOutlet weak var briefingTableView: UITableView!
    
    // MARK: - Data
    var model: BriefingViewModel!
    var isTodayOpen = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }
    
    // MARK: - After loaded setup
    
    private func setup() {
        Observable<UIEdgeInsets>.just(UIEdgeInsets(top: 13, left: 0, bottom: 0, right: 0))
            .bind(to: briefingTableView.rx.contentInset)
            .disposed(by: bag)
    }
    
    private func bind() {
        model.rows.map { rows in
            guard let first = rows.first else {
                return false
            }
            
            switch first.1 {
            case .today(_):
                return true
            case .suggestions(_, _):
                return false
            }
        }.subscribe(onNext: {
            self.isTodayOpen = $0
        }).disposed(by: bag)
        
        model.rows.bind(to: briefingTableView.rx.items) { table, index, element in
            switch element.1 {
            case .suggestions(let prints, let userId):
                let cell = table.dequeueReusableCell(withIdentifier: SuggestionsBoxCell.reuseIdentifier, for: IndexPath(row: index, section: 0))
                if let suggestionsBoxCell = cell as? SuggestionsBoxCell {
                    suggestionsBoxCell.model = SuggestionsBox(title: element.0, prints: prints, forUser: userId)
                    return suggestionsBoxCell
                } else { return cell }
            case .today(let blueprint):
                let cell = table.dequeueReusableCell(withIdentifier: TodayCell.reuseIdentifier, for: IndexPath(row: index, section: 0))
                if let todayCell = cell as? TodayCell {
                    todayCell.model = blueprint
                    return todayCell
                } else { return cell }
            }
        }.disposed(by: bag)
    }

}

extension BriefingController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0, self.isTodayOpen {
            return K.Measurement.summaryHeight
        } else {
            return K.Measurement.carouselHeight
        }
    }
    
}
