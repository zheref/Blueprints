import Foundation
import RxSwift

class HomeViewModel {

    var bag = DisposeBag()

    // MARK: - Observables
    var dates: Observable<[BlueDate]>
    var assignedDays = BehaviorSubject<[Day]>(value: [])
    var selectedDay = BehaviorSubject<Day?>(value: nil)
    var unassignClicked = PublishSubject<BlueDate>()
    var pinClicked = PublishSubject<BlueDate>()
    
    init() {
        let assignmentsService = try! ServicesContainer.shared.resolve() as IAssignmentsServive
        let daysService = try! ServicesContainer.shared.resolve() as DaysServiceProtocol

        // TODO: Make actual sequence later for actual day changes (app in foreground over mid-night)
        dates = daysService.resolveAround(date: Date()).map { $0.map { $0.date } }
        
        // TODO: Is this even valid or a good practice?
        dates.subscribe(onNext: { [weak self] dates in
            guard let this = self else { return }
            assignmentsService.fetchAndMix(withDates: dates).subscribe(onNext: { [weak self] assignedDays in
                guard let this = self else { return }
                this.assignedDays.on(.next(assignedDays))
            }).disposed(by: this.bag)
        }).disposed(by: bag)
    }
    
    lazy var forBriefing: BriefingViewModel = {
        BriefingViewModel(
            assignedDays: self.assignedDays,
            selectedDay: self.selectedDay
        )
    }()

    func viewIsPrepared() {
        unassignClicked.subscribe(onNext: userDidUnassign)
    }

    private func userDidUnassign(date: BlueDate) {
        let assignmentsService = try! ServicesContainer.shared.resolve() as IAssignmentsServive
        let authService = try! ServicesContainer.shared.resolve() as IAuthService

        assignmentsService
            .unassign(date: date, forUserId: authService.currentUserId)
            .subscribe { event in
                print("Succeeded unassigning")
            }.disposed(by: bag)
    }
    
    func selectedDayAt(index: Int) {
        // TODO: AssignedDays should become a behaviorRelay??
        assignedDays.take(1).subscribe(onNext: { [weak self] days in
            self?.selectedDay.onNext(days[index])
        }).disposed(by: bag)
    }
    
}
