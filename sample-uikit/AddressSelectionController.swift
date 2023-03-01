import UIKit

extension Division {

    static func china() -> Division {
        let url = Bundle.main.url(forResource: "AdministrativeDivisions", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return try! JSONDecoder().decode(Division.self, from: data)
    }
}

protocol AddressSelectionControllerDelegate: AnyObject {

    func controller(_ controller: AddressSelectionController, didSelect address: [String])

    func controllerToDismiss(_ controller: AddressSelectionController)
}

class AddressSelectionController: UIViewController {

    weak var delegate: AddressSelectionControllerDelegate?

    var maxDepth: Int

    var selectedAddress: [String]

    var viewControllers = [DivisionViewController(division: .china())]

    var rootViewController: DivisionViewController {
        return viewControllers[0]
    }

    override var navigationItem: UINavigationItem {
        return rootViewController.navigationItem
    }

    init(maxDepth: Int = 3) {
        self.maxDepth = maxDepth
        self.selectedAddress = [String](repeating: "", count: maxDepth)
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        rootViewController.delegate = self
        embed(rootViewController)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }
}

extension AddressSelectionController: DivisionViewControllerDelegate {

    func viewController(_ viewController: DivisionViewController, didSelect subdivision: Division) {
        guard let index = viewControllers.firstIndex(of: viewController) else { return }
        selectedAddress[index] = subdivision.name
        if index + 1 == maxDepth {
            delegate?.controller(self, didSelect: selectedAddress)
        } else {
            let next = DivisionViewController(division: subdivision)
            next.delegate = self
            if index + 1 == viewControllers.count {
                viewControllers.append(next)
            } else {
                viewControllers[index+1] = next
            }
            navigationController?.pushViewController(next, animated: true)
        }
    }

    func viewControllerToDismiss(_ viewController: DivisionViewController) {
        delegate?.controllerToDismiss(self)
    }
}
