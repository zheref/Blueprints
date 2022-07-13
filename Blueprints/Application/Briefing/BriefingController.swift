//
//  BriefingController.swift
//  Blueprints
//
//  Created by Sergio Lozano on 18/07/22.
//

import UIKit
import RxSwift
import RxCocoa

class BriefingController: UIViewController {
    
    @IBOutlet weak var briefingTableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    var model: BriefingViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        model.rows.bind(to: briefingTableView.rx.items(cellIdentifier: SuggestionsCell.reuseIdentifier, cellType: SuggestionsCell.self)) { row, element, cell in
            guard case let .suggestions(prints, userId) = element.1 else {
                // Do nothing: no data
                return
            }
            cell.model = SuggestionsBox(title: element.0, prints: prints, forUser: userId)
        }.disposed(by: disposeBag)
    }

}

extension BriefingController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        185.0
    }
    
}
