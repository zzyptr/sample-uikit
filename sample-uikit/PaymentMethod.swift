struct PaymentMethod {

    let card: Card
    let billingAddress: BillingAddress

    var cardholderName: String {
        return billingAddress.firstName + billingAddress.lastName
    }
}
