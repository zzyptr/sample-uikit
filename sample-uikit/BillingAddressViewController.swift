import UIKit

protocol BillingAddressViewControllerDelegate: AnyObject {

    func viewControllerToSelectAddress(_ viewController: BillingAddressViewController)

    func viewController(_ viewController: BillingAddressViewController, didCommit info: BillingAddress)
}

extension BillingAddressViewController {

    static func instantiate() -> BillingAddressViewController {
        let board = UIStoryboard(name: "Main", bundle: nil)
        let instance = board.instantiateViewController(withIdentifier: "BillingAddressViewController")
        return instance as! BillingAddressViewController
    }
}

class BillingAddressViewController: UITableViewController {

    weak var delegate: BillingAddressViewControllerDelegate?

    var generalAddress = "" {
        didSet {
            firstAddressField.text = generalAddress
            lastAddressField.becomeFirstResponder()
        }
    }

    @IBOutlet weak var commitButton: UIBarButtonItem!

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var firstAddressField: UITextField!
    @IBOutlet weak var lastAddressField: UITextField!
    @IBOutlet weak var postalCodeField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!

    @IBAction
    func commit() {
        let info = BillingAddress(
            firstName: firstNameField.text ?? "",
            lastName: lastNameField.text ?? "",
            address: (firstAddressField.text ?? "") + (lastAddressField.text ?? ""),
            postalCode: postalCodeField.text ?? "",
            phoneNumber: phoneNumberField.text ?? ""
        )
        delegate?.viewController(self, didCommit: info)
    }
}

extension BillingAddressViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField === firstAddressField || textField === lastAddressField && generalAddress.isEmpty {
            delegate?.viewControllerToSelectAddress(self)
            return false
        }
        return true
    }

    @IBAction
    func textFieldEditingDidChange(_ textField: UITextField) {
        commitButton.isEnabled = [
            firstNameField,
            lastNameField,
            firstAddressField,
            lastAddressField,
            postalCodeField,
            phoneNumberField
        ].allSatisfy { each in
            each.text != nil && each.text != ""
        }
    }
}
