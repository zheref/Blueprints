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
        K.Measurement.carouselHeight
    }
    
}
