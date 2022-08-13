import Foundation
import UIKit
import RxSwift
import RxCocoa

extension HomeViewController: UICollectionViewDelegate {
    
    func expectedCellSize() -> CGSize { CGSize(width: 80, height: 120) }
    
    func setupMiniCalendar() {
        Observable.just(UICollectionView.ScrollDirection.horizontal)
            .bind(to: calendarCollectionViewLayout.rx.scrollDirection)
            .disposed(by: bag)
        
        Observable.just(expectedCellSize())
            .bind(to: calendarCollectionViewLayout.rx.itemSize)
            .disposed(by: bag)
        
        model.assignedDays.bind(to: calendarCollectionView.rx.items(cellIdentifier: DayCell.identifier, cellType: DayCell.self)) { (row, element, cell) in
            cell.setSelected(false)
            cell.model = DayViewModel(day: element)
        }.disposed(by: bag)
        
        model.assignedDays.subscribe(onNext: { [weak self] days in
            guard let self = self else { return }
            
            self.calendarCollectionView.contentSize = CGSize(
                width: self.expectedCellSize().width * CGFloat(days.count),
                height: self.expectedCellSize().height
            )
        }).disposed(by: bag)
        
        calendarCollectionView
            .rx
            .modelSelected(Day.self)
            .subscribe(onNext: { [weak self] day in
                if let selectedIndexes = self?.calendarCollectionView.indexPathsForSelectedItems,
                   let onlySelectedIndex = selectedIndexes.first,
                   let selectedCell = self?.calendarCollectionView.cellForItem(at: onlySelectedIndex) as? DayCell {
                    selectedCell.model = DayViewModel(day: day)
                }
            })
            .disposed(by: bag)
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        expectedCellSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DayCell {
            cell.setSelected(true)
            model.selectDateAtIndex.onNext(indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DayCell {
            cell.setSelected(false)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemAt indexPath: IndexPath,
                        point: CGPoint) -> UIContextMenuConfiguration? {

        UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let unassignAction = UIAction(title: "Unassign", image: nil) { [weak self] action in
                guard let this = self else { return }
                this.model.dates
                    .map { $0[indexPath.item] }
                    .take(1)
                    .subscribe(onNext: this.model.unassignClicked.onNext)
                    .disposed(by: this.bag)
            }

            let pinAction = UIAction(title: "Pin", image: nil) { [weak self] action in
//                guard let print = self?.model.prints[indexPath.item] else { return }
//                self?.model.pinClicked.onNext(print)
            }

            return UIMenu(title: "", children: [unassignAction, pinAction])
        }
    }
}
