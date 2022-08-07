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
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        expectedCellSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DayCell {
            cell.setSelected(true)
            model.selectedDayAt(index: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DayCell {
            cell.setSelected(false)
        }
    }
}
