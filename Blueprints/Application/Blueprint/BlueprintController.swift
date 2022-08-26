import UIKit

class BlueprintController: BlueTableController, Loggable {
    
    // MARK: - Loggable
    
    static var logCategory: String { String(describing: BlueprintController.self) }
    
    // MARK: - Reactive
    
    var model: BlueprintViewModel! {
        didSet { connect() }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        model.event.onNext(.ready)
    }
    
    private func connect() {
        model.event.subscribe(onNext: { [weak self] event in
            switch event {
            case .preparing:
                break
            case .ready:
                self?.setup()
                self?.bind()
            }
        }).disposed(by: bag)
    }
    
    private func setup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(userDidTapSave))
        
        addRows()
    }
    
    private func bind() {
        tableView.rx.setDelegate(self).disposed(by: bag)
        tableView.rx.setDataSource(self).disposed(by: bag)
        
//        if let imageUrl = model.blueprint.pictureUrl {
//            pullImage(withUrlString: imageUrl)
//        }
        
        
    }
    
    private func addRows() {
        let cell = SingleLineDetailCell(frame: CGRect(
            origin: CGPoint(x: 0, y: 700.0),
            size: CGSize(width: tableView.bounds.width, height: 100.0))
        )
        
        tableView.addSubview(cell)
    }
    
    
    
    private func pullImage(withUrlString urlString: String) {
        let storageService = try! ServicesContainer.shared.resolve() as StorageServiceProtocol
        
        storageService.downloadImage(named: urlString)
            .subscribe(onSuccess: { [weak self] imageData in
//                self?.pictureView.image = UIImage(data: imageData)
            }, onFailure: { error in
                Self.logger.error("Error downloading image \(error.localizedDescription)")
            })
            .disposed(by: bag)
    }
    
    // MARK: - User Actions
    
    @objc private func userDidTapSave() {
        
    }
    
    // MARK: - Table view
    
//    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        if let headerView = view as? UITableViewHeaderFooterView {
//            headerView.textLabel?.text = model.blueprint.attribute.uppercased()
//        }
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}
