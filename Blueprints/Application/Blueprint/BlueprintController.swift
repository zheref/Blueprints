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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: self,
                                                            action: #selector(userDidTapEdit))
        
        tableView.register(SingleLineDetailCell.self, forCellReuseIdentifier: SingleLineDetailCell.reuseIdentifier)
        tableView.register(PrintImageCell.self, forCellReuseIdentifier: PrintImageCell.reuseIdentifier)
        tableView.register(CustomLineDetailCell.self, forCellReuseIdentifier: CustomLineDetailCell.reuseIdentifier)
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
                        if let imageUrlString = aspect.associatedValue as? String {
                            printImageCell.configure(withUrlString: imageUrlString)
                        }
                    }
                    
                    return cell
                case .ratios:
                    let cell = tableView.dequeueReusableCell(withIdentifier: RatioTrioCell.reuseIdentifier) as? RatioTrioCell ?? RatioTrioCell(style: .default, reuseIdentifier: RatioTrioCell.reuseIdentifier)
                    
                    if let ratios = aspect.associatedValue as? BlueRatios {
                        cell.configure(withRatios: ratios)
                    }
                    
                    return cell
                case .simple:
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: SingleLineDetailCell.reuseIdentifier,
                        for: indexPath
                    ) as! SingleLineDetailCell
                    if let value = aspect.associatedValue as? String {
                        cell.configure(withCaption: aspect.caption, withValue: value)
                    }
                    return cell
                case .colors:
                    let cell = tableView.dequeueReusableCell(withIdentifier: CustomLineDetailCell.reuseIdentifier, for: indexPath) as! CustomLineDetailCell
                    
                    if let colors = aspect.associatedValue as? [PrintColor] {
                        let customValueView = ColorsTrioView(colors: colors)
                        cell.configure(withCaption: aspect.caption, andCustomView: customValueView)
                    }
                    return cell
                }
            }
        )
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model.title
        }
        
        model.sections.map { sections in
            sections.compactMap { section -> BlueprintSectionModel? in
                if case let .blueprint(_, aspects) = section {
                    return BlueprintSectionModel(
                        model: section,
                        items: aspects
                    )
                } else if case let .work(aspects) = section, !aspects.isEmpty {
                    return BlueprintSectionModel(
                        model: section,
                        items: aspects
                    )
                } else if case let .train(aspects) = section, !aspects.isEmpty {
                    return BlueprintSectionModel(
                        model: section,
                        items: aspects
                    )
                } else if case let .chill(aspects) = section, !aspects.isEmpty {
                    return BlueprintSectionModel(
                        model: section,
                        items: aspects
                    )
                } else if case let .notes(aspects) = section, !aspects.isEmpty {
                    return BlueprintSectionModel(
                        model: section,
                        items: aspects
                    )
                } else {
                    return nil
                }
            }
        }
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: bag)
    }
    
    // MARK: - User Actions
    
    @objc private func userDidTapEdit() {
        let alert = UIAlertController(title: "😎", message: "Edition is coming soon!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Neat!", style: .default))
        present(alert, animated: true)
    }

}
