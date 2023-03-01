import UIKit

protocol DivisionViewControllerDelegate: AnyObject {

    func viewController(_ viewController: DivisionViewController, didSelect subdivision: Division)

    func viewControllerToDismiss(_ viewController: DivisionViewController)
}

class DivisionViewController: UITableViewController {

    let cellReuseIdentifier = "UITableViewCell"

    weak var delegate: DivisionViewControllerDelegate?

    var division: Division

    init(division: Division) {
        self.division = division
        super.init(style: .plain)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = division.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(toDismiss)
        )
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }

    func updateDivision(to newValue: Division) {
        division = newValue
        navigationItem.title = newValue.name
        tableView.reloadData()
    }

    @objc
    func toDismiss() {
        delegate?.viewControllerToDismiss(self)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return division.subdivisions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let division = division.subdivisions[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = division.name
        cell.contentConfiguration = config
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selection = division.subdivisions[indexPath.row]
        delegate?.viewController(self, didSelect: selection)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }
}
