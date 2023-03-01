import UIKit

protocol PaymentMethodControllerDelegate: AnyObject {

    func controller(_ controller: PaymentMethodController, didCollect paymentMethod: PaymentMethod)
}

class PaymentMethodController: UIViewController {

    weak var delegate: PaymentMethodControllerDelegate?

    var savedCard = Card(number: "", validDate: "", secureCode: "")

    lazy var cardViewController = CardViewController.instantiate()

    lazy var billingAddressViewController = BillingAddressViewController.instantiate()

    override var navigationItem: UINavigationItem {
        return cardViewController.navigationItem
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        cardViewController.delegate = self
        embed(cardViewController)
        billingAddressViewController.delegate = self
    }
}

extension PaymentMethodController: CardViewControllerDelegate {

    func viewController(_ viewController: CardViewController, didCommit card: Card) {
        savedCard = card
        navigationController?.pushViewController(billingAddressViewController, animated: true)
    }
}

extension PaymentMethodController: BillingAddressViewControllerDelegate {

    func viewControllerToSelectAddress(_ viewController: BillingAddressViewController) {
        let addressSelector = AddressSelectionController()
        addressSelector.delegate = self
        navigationController?.pushViewController(addressSelector, animated: true)
    }

    func viewController(_ viewController: BillingAddressViewController, didCommit billingAddress: BillingAddress) {
        let paymentMethod = PaymentMethod(card: savedCard, billingAddress: billingAddress)
        delegate?.controller(self, didCollect: paymentMethod)
    }
}

extension PaymentMethodController: AddressSelectionControllerDelegate {

    func controller(_ controller: AddressSelectionController, didSelect address: [String]) {
        billingAddressViewController.generalAddress = address.joined()
        navigationController?.popToViewController(billingAddressViewController, animated: true)
    }

    func controllerToDismiss(_ controller: AddressSelectionController) {
        navigationController?.popToViewController(self, animated: true)
    }
}
