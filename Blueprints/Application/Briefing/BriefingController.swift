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
        model.rows.subscribe(onNext: { briefingRows in
            print("zheref: BriefingRows:", briefingRows)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
        
        model.rows.bind(to: briefingTableView.rx.items(cellIdentifier: SuggestionsBoxCell.reuseIdentifier, cellType: SuggestionsBoxCell.self)) {
            guard case let .suggestions(prints, userId) = $1.1 else { return }
            $2.model = SuggestionsBox(title: $1.0, prints: prints, forUser: userId)
        }.disposed(by: bag)
        
        // Potential solution for multiple types of cells
//        model.rows.bind(to: briefingTableView.rx.items) { table, index, element in
//        }.disposed(by: disposeBag)
    }

}

extension BriefingController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        170.0
    }
    
}
