import Foundation
import UIKit
import RxSwift
import RxCocoa

extension HomeViewController: UICollectionViewDelegate {
    
    func setupMiniCalendar() {
        let calendarDaySize = CGSize(width: 80, height: 120)
        
        calendarCollectionViewLayout.scrollDirection = .horizontal
//        calendarCollectionViewLayout.itemSize = CGSize(width: 80, height: 120)
        
        let _ = Observable.just(CGSize(width: 80, height: 120)).bind(to: calendarCollectionViewLayout.rx.itemSize)
        
        model.days.bind(to: calendarCollectionView.rx.items(cellIdentifier: DayCell.identifier, cellType: DayCell.self)) { (row, element, cell) in
            cell.model = DayViewModel(day: element)
        }.disposed(by: disposeBag)
        
        model.days.subscribe { [weak self] days in
            self?.calendarCollectionView.contentSize = CGSize(
                width: calendarDaySize.width * CGFloat(days.count),
                height: 120
            )
        } onError: { error in
            print(error)
        } onCompleted: { [weak self] in
            print("days: completed", self?.model.days as Any)
        } onDisposed: {
            print("days model disposed")
        }.disposed(by: disposeBag)
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 120)
    }
}
