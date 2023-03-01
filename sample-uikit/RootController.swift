import UIKit

final class RootController: UINavigationController {

    init() {
        let viewController = ViewController.instantiate()
        super.init(rootViewController: viewController)
        viewController.delegate = self
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

extension RootController: ViewControllerDelegate {

    func viewControllerToAddPaymentMethod(_ viewController: ViewController) {
        let paymentMethodController = PaymentMethodController()
        paymentMethodController.delegate = self
        pushViewController(paymentMethodController, animated: true)
    }
}

extension RootController: PaymentMethodControllerDelegate {

    func controller(_ controller: PaymentMethodController, didCollect paymentMethod: PaymentMethod) {
        popToRootViewController(animated: true)

        let alert = UIAlertController(
            title: paymentMethod.cardholderName,
            message: [
                paymentMethod.card.number,
                paymentMethod.billingAddress.address,
                paymentMethod.billingAddress.phoneNumber
            ].joined(separator: "\n"),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "ok", style: .default))
        present(alert, animated: true)
    }
}
