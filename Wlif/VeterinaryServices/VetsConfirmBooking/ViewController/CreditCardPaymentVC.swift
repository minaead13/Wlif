//
//  CreditCardPaymentVC.swift
//  Wlif
//
//  Created by OSX on 21/09/2025.
//

import UIKit
import SwiftUI
import MoyasarSdk // Correct import

class CreditCardPaymentVC: UIViewController {
    var onPaymentSuccess: (() -> Void)?
    var onPaymentFailure: ((Error) -> Void)?
    var paymentRequest: PaymentRequest? // Declare a property to hold the request

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ensure a valid request was passed
        guard let request = paymentRequest else {
            // Handle the error if the request is nil
            let error = NSError(domain: "CreditCardPaymentVCError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Payment request data is missing."])
            onPaymentFailure?(error)
            return
        }

        // Create the SwiftUI CreditCardView
        let creditCardView = MoyasarSdk.CreditCardView(request: request) { result in
            switch result {
            case .completed(let payment):
                // Payment process is complete. Check the status.
                if payment.status.rawValue == "paid" {
                    self.onPaymentSuccess?()
                } else {
                    let error = NSError(domain: "MoyasarPaymentError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Payment status is not 'paid': \(payment.status)"])
                    self.onPaymentFailure?(error)
                }
            case .failed(let error):
                // Payment failed.
                self.onPaymentFailure?(error)
            case .canceled:
                // User canceled the payment flow.
                print("Payment canceled by user.")
            case .saveOnlyToken(_):
                print("save.")
            }
            // Dismiss the view controller after the result
            self.dismiss(animated: true, completion: nil)
        }

        // Embed the SwiftUI view in a UIHostingController
        let hostingController = UIHostingController(rootView: creditCardView)
        
        // Add the hosting controller as a child view controller
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.didMove(toParent: self)
    }
}
