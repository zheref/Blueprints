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
        model.viewIsPrepared()
        setup()
    }
    
    // MARK: - After loaded setup
    private func setup() {
        bind()
    }
    
    private func bind() {
        Observable<UIEdgeInsets>.just(UIEdgeInsets(top: 13, left: 0, bottom: 0, right: 0))
            .bind(to: briefingTableView.rx.contentInset)
            .disposed(by: bag)
        
        briefingTableView.rx.setDelegate(self).disposed(by: bag)
        
        model.rows.bind(to: briefingTableView.rx.items) { [weak self] table, index, element in
            switch element.1 {
            case .suggestions(let prints, let userId):
                let cell = table.dequeueReusableCell(withIdentifier: SuggestionsBoxCell.reuseIdentifier, for: IndexPath(row: index, section: 0))
                if let suggestionsBoxCell = cell as? SuggestionsBoxCell {
                    let box = SuggestionsBox(title: element.0, prints: prints, forUser: userId)
                    suggestionsBoxCell.model = SuggestionsBoxViewModel(box: box)
                    if let this = self {
                        suggestionsBoxCell.model.assignClicked
                            .subscribe(onNext: this.model.userDidAssignToDate)
                            .disposed(by: suggestionsBoxCell.model.bag)
                        suggestionsBoxCell.model.printSelected
                            .subscribe(onNext: this.model.userDidSelect(bprint:))
                            .disposed(by: suggestionsBoxCell.model.bag)
                    }
                    return suggestionsBoxCell
                } else { return cell }
            case .summary(let blueday):
                let cell = table.dequeueReusableCell(withIdentifier: SummaryCell.reuseIdentifier, for: IndexPath(row: index, section: 0))
                if let summaryCell = cell as? SummaryCell {
                    summaryCell.model = SummaryViewModel(blueday: blueday)
                    if let self = self {
                        summaryCell.model.event
                            .take(while: { $0 == .userDidTapPrintImage })
                            .subscribe(onNext: { _ in self.model.userDidSelect(bprint: blueday.blueprint) })
                            .disposed(by: summaryCell.model.bag)
                    }
                    return summaryCell
                } else { return cell }
            }
        }.disposed(by: bag)
        
//        briefingTableView
//            .rx
//            .modelSelected(BriefingRow.self)
//            .subscribe(onNext: { [weak self] row in
//                if case let .suggestions(bluePrints, userId
//            })
    }

}

extension BriefingController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0, model.isSummaryOpen {
            return K.Measurement.summaryHeight
        } else {
            return K.Measurement.carouselHeight
        }
    }
    
}
