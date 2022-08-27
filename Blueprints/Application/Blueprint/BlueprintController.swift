import UIKit
import RxCocoa
import RxDataSources

typealias BlueprintSectionModel = SectionModel<BlueprintSection, Any>

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
        
        tableView.register(SingleLineDetailCell.self, forCellReuseIdentifier: SingleLineDetailCell.reuseIdentifier)
        tableView.register(PrintImageCell.self, forCellReuseIdentifier: PrintImageCell.reuseIdentifier)
    }
    
    private func bind() {
        tableView.delegate = nil
        tableView.dataSource = nil
        
        let dataSource = RxTableViewSectionedReloadDataSource<BlueprintSectionModel>(
            configureCell: { dataSource, tableView, indexPath, item in
                guard let aspect = item as? AspectModel else {
                    let simpleCellIdentifier = "simpleCellIdentifier"
                    return tableView.dequeueReusableCell(
                        withIdentifier: simpleCellIdentifier
                    ) ?? UITableViewCell(
                        style: .default,
                        reuseIdentifier: simpleCellIdentifier
                    )
                }
                
                switch aspect.kind {
                case .coverImage:
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: PrintImageCell.reuseIdentifier
                    ) ?? PrintImageCell(style: .default, reuseIdentifier: PrintImageCell.reuseIdentifier)
                    
                    if let printImageCell = cell as? PrintImageCell {
                        printImageCell.contentView.snp.makeConstraints { make in
                            make.height.equalTo(400)
                        }
                        printImageCell.contentView.backgroundColor = UIColor.yellow
                        
                        if let imageUrlString = aspect.associatedValue as? String {
                            printImageCell.imageUrlString = imageUrlString
                        }
                    }
                    
                    return cell
                case .simple:
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: SingleLineDetailCell.reuseIdentifier,
                        for: indexPath
                    ) as! SingleLineDetailCell
                    cell.contentView.snp.makeConstraints { make in
                        make.height.equalTo(80)
                    }
                    cell.contentView.backgroundColor = UIColor.cyan
                    if let value = aspect.associatedValue as? String {
                        cell.value = value
                    }
                    return cell
                case .colors:
                    let simpleCellIdentifier = "simpleCellIdentifier"
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: simpleCellIdentifier
                    ) ?? UITableViewCell(
                        style: .default,
                        reuseIdentifier: simpleCellIdentifier
                    )
                    if let colors = aspect.associatedValue as? [PrintColor] {
                        cell.textLabel?.text = "\(colors.count) colors"
                    }
                    return cell
                }
            }
        )
        
        model.sections.map { sections in
            sections.map { section -> BlueprintSectionModel in
                if case let .blueprint(aspects) = section {
                    return BlueprintSectionModel(
                        model: section,
                        items: aspects
                    )
                } else {
                    return BlueprintSectionModel(
                        model: section,
                        items: []
                    )
                }
            }
        }
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: bag)
    }
    
    
    

    
    // MARK: - User Actions
    
    @objc private func userDidTapSave() {
        
    }

}
