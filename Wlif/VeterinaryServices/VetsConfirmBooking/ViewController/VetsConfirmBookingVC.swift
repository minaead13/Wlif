//
//  VetsConfirmBookingVC.swift
//  Wlif
//
//  Created by OSX on 23/07/2025.
//

import UIKit
import PassKit
import MoyasarSdk

class VetsConfirmBookingVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    
    let viewModel = VetsConfirmBookingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupTableView()
        bind()
        setupHeaderActions()
    }
    
    func setupTableView() {
        tableView.registerCell(cell: nameDetailsTableViewCell.self)
        tableView.registerCell(cell: ServiceDataTableViewCell.self)
        tableView.registerCell(cell: PaymentMethodTableViewCell.self)
        tableView.registerCell(cell: PaymentInfoTableViewCell.self)
    }
    
    func bind() {
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self = self,
                  let isLoading = isLoading else {
                return
            }
            DispatchQueue.main.async {
                if isLoading {
                    self.showLoadingIndicator()
                } else {
                    self.hideLoadingIndicator()
                }
            }
        }
    }

    func setupHeaderActions() {
        headerView.onCartTap = { [weak self] in
            self?.navigate(to: CartViewController.self, from: "Home", storyboardID: "CartViewController")
        }
        
        headerView.onSideMenuTap = { [weak self] in
            self?.navigate(to: SettingsViewController.self, from: "Profile", storyboardID: "SettingsViewController")
        }
        
        headerView.onHomeTap = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
   
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func didTapContinueBtn(_ sender: Any) {
        viewModel.addVetOrder { [weak self] result in
            switch result {
            case .success(let data):
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ConfirmOrderVC") as! ConfirmOrderVC
                self?.navigationController?.pushViewController(vc, animated: true)
                
            case .failure(let error):
                print("Failed to add order: \(error.localizedDescription)")
            }
        }
    }
    
}

extension VetsConfirmBookingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "nameDetailsTableViewCell", for: indexPath) as? nameDetailsTableViewCell else { return UITableViewCell()}
            
            cell.vetImageView.setImage(from: viewModel.store?.image)
            cell.nameLabel.text = viewModel.store?.name
            cell.locationLabel.text = viewModel.store?.distance
            cell.selectionStyle = .none
            return cell
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceDataTableViewCell", for: indexPath) as? ServiceDataTableViewCell else { return UITableViewCell()}
            cell.serviceTypeLabel.text = viewModel.serviceType
            cell.dateLabel.text = viewModel.date
            cell.timeLabel.text = viewModel.selectedTime?.time
            cell.animalTypes = viewModel.selectedAnimalTypes
            cell.selectionStyle = .none
            return cell
            
        case 2:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodTableViewCell", for: indexPath) as? PaymentMethodTableViewCell else { return UITableViewCell()}
            cell.completionHandler = { [weak self] in
                guard let self = self else { return }
                do {
                    let amount = self.viewModel.category?.price ?? 0
                    
                    // This is the line that can throw
                    let request = try PaymentRequest(
                        apiKey: "YOUR_PUBLISHABLE_API_KEY",
                        amount: amount,
                        currency: "SAR",
                        description: "Veterinary booking for \(self.viewModel.store?.name ?? "")"
                    )
                    
                    let vc = CreditCardPaymentVC()
                    vc.paymentRequest = request // Pass the valid request
                    
                    // Set up the completion handlers for success and failure
                    vc.onPaymentSuccess = { [weak self] in
                        self?.viewModel.addVetOrder { addOrderResult in
                            // ... (existing success logic)
                        }
                    }
                    
                    vc.onPaymentFailure = { error in
                     
                    }
                    
                    self.present(vc, animated: true, completion: nil)
                } catch {
                    // Handle the error if the PaymentRequest creation fails
                    print("Failed to create payment request: \(error.localizedDescription)")
                    let alert = UIAlertController(title: "Payment Error", message: "An error occurred while preparing for payment. Please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            cell.selectionStyle = .none
            return cell
            
        case 3:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentInfoTableViewCell", for: indexPath) as? PaymentInfoTableViewCell else { return UITableViewCell()}
            cell.totalLabel.text = "\(viewModel.category?.price ?? 0) \("SR".localized)"
            cell.subTotalLabel.text = "\(viewModel.category?.price ?? 0) \("SR".localized)"
            cell.selectionStyle = .none
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}

extension VetsConfirmBookingVC: PKPaymentAuthorizationControllerDelegate {
    
    func startApplePayPayment() {
        let paymentRequest = PKPaymentRequest()
        
        paymentRequest.merchantIdentifier = "merchant.your.merchant.id"
        paymentRequest.countryCode = "SA"
        paymentRequest.currencyCode = "SAR"
        paymentRequest.supportedNetworks = [.visa, .masterCard, .mada]
        paymentRequest.merchantCapabilities = [.capability3DS, .capabilityCredit, .capabilityDebit]
        
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Booking Payment", amount: NSDecimalNumber(string: "\(viewModel.category?.price ?? 0)"))
        ]
        
        let controller = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        controller.delegate = self
        controller.present(completion: nil)
    }
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController,
                                        didAuthorizePayment payment: PKPayment,
                                        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
//        MoyasarSDK.createApplePayPayment(token: payment.token, amount: viewModel.category?.price ?? 0, currency: "SAR", description: "Booking Payment") { result in
//            
//            switch result {
//            case .success(let paymentResult):
//                if paymentResult.status == "paid" {
//                    completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
//                    self.handlePaymentSuccess(paymentResult)
//                } else {
//                    completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
//                }
//            case .failure(let error):
//                print("Payment failed: \(error.localizedDescription)")
//                completion(PKPaymentAuthorizationResult(status: .failure, errors: [error]))
//            }
        // }
    }

    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss()
    }
    
}
