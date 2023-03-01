import UIKit

protocol ViewControllerDelegate: AnyObject {

    func viewControllerToAddPaymentMethod(_ viewController: ViewController)
}

extension ViewController {

    static func instantiate() -> ViewController {
        let board = UIStoryboard(name: "Main", bundle: nil)
        let instance = board.instantiateViewController(withIdentifier: "ViewController")
        return instance as! ViewController
    }
}

class ViewController: UIViewController {

    weak var delegate: ViewControllerDelegate?

    @IBAction
    func toAddPaymentMethod() {
        delegate?.viewControllerToAddPaymentMethod(self)
    }
}
