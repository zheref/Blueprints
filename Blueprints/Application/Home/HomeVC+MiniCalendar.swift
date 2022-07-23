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
        
        model.days.bind(to: calendarCollectionView.rx.items(cellIdentifier: DayCell.identifier, cellType: DayCell.self)) { (row, element, cell) in
            cell.model = DayViewModel(day: element)
        }.disposed(by: bag)
        
        model.days.subscribe { [weak self] days in
            guard let self = self else { return }
            
            self.calendarCollectionView.contentSize = CGSize(
                width: self.expectedCellSize().width * CGFloat(days.count),
                height: self.expectedCellSize().height
            )
        } onError: { error in
            print(error)
        } onCompleted: { [weak self] in
            print("days: completed", self?.model.days as Any)
        } onDisposed: {
            print("days model disposed")
        }.disposed(by: bag)
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        expectedCellSize()
    }
}
