import UIKit

class BlueprintController: BlueTableController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var pictureView: UIImageView!
    
    // MARK: - Reactive
    
    var model: BlueprintViewModel!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        model.viewIsPrepared()
    }
    
    private func setup() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(userDidTapSave))
        bind()
    }
    
    private func bind() {
        if let firstSectionHeader = tableView.headerView(forSection: 0) {
            firstSectionHeader.textLabel?.text = model.blueprint.attribute
        }
        
        if let imageUrl = model.blueprint.pictureUrl {
            pullImage(withUrlString: imageUrl)
        }
    }
    
    private func pullImage(withUrlString urlString: String) {
        let storageService = try! ServicesContainer.shared.resolve() as StorageServiceProtocol
        
        storageService.downloadImage(named: urlString)
            .subscribe(onSuccess: { [weak self] imageData in
                self?.pictureView.image = UIImage(data: imageData)
            }, onFailure: { error in
                print("Error downloading image", error.localizedDescription)
            })
            .disposed(by: bag)
    }
    
    // MARK: - User Actions
    
    @objc private func userDidTapSave() {
        
    }

    // MARK: - Table view data source

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

}
