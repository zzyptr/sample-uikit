import UIKit

protocol CardViewControllerDelegate: AnyObject {

    func viewController(_ viewController: CardViewController, didCommit card: Card)
}

extension CardViewController {

    static func instantiate() -> CardViewController {
        let board = UIStoryboard(name: "Main", bundle: nil)
        let instance = board.instantiateViewController(withIdentifier: "CardViewController")
        return instance as! CardViewController
    }
}

class CardViewController: UITableViewController {

    weak var delegate: CardViewControllerDelegate?

    @IBOutlet weak var commitButton: UIBarButtonItem!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var validDateField: UITextField!
    @IBOutlet weak var secureCodeField: UITextField!

    @IBAction
    func commit() {
        let card = Card(
            number: numberField.text ?? "",
            validDate: validDateField.text ?? "",
            secureCode: secureCodeField.text ?? ""
        )
        delegate?.viewController(self, didCommit: card)
    }

    @IBAction
    func textFieldEditingDidChange(_ textField: UITextField) {
        commitButton.isEnabled = [
            numberField,
            validDateField,
            secureCodeField
        ].allSatisfy { each in
            each.text != nil && each.text != ""
        }
    }
}
