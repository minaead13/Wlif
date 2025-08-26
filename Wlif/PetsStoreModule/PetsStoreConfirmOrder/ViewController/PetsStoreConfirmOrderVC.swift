//
//  PetsStoreConfirmOrderVC.swift
//  Wlif
//
//  Created by OSX on 03/08/2025.
//

import UIKit

class PetsStoreConfirmOrderVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = PetsStoreConfirmOrderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        setupTableView()
        bind()
    }
    
    func setupTableView() {
        tableView.registerCell(cell: PetStoreLocationAndProductsCell.self)
        tableView.registerCell(cell: PaymentMethodTableViewCell.self)
        tableView.registerCell(cell: StorePaymentInfoTableViewCell.self)
        tableView.registerCell(cell: DeliveryFeesTableViewCell.self)
    }
    
    
    func bind() {
        viewModel.onOrderConfirmed = { [weak self] cart in
            DispatchQueue.main.async { [weak self] in
                let stoyboard = UIStoryboard(name: "VeterinaryServices", bundle: nil)
                let vc = stoyboard.instantiateViewController(withIdentifier: "ConfirmOrderVC") as! ConfirmOrderVC
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
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
    
    @IBAction func didTapContinueBtn(_ sender: Any) {
        if LocationUtil.load() != nil {
            viewModel.addStoreOrder()
        }
    }
    
    @IBAction func didTapBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension PetsStoreConfirmOrderVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PetStoreLocationAndProductsCell", for: indexPath) as? PetStoreLocationAndProductsCell else {
                return UITableViewCell()
            }
            
            cell.handleLocationSelection = { [weak self] in
                let storyboard = UIStoryboard(name: "Adoption", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
                
                vc.viewModel.completionHandler = { [weak self] in
                    guard let self else { return }
                    cell.locationLabel.text = LocationUtil.load()?.address
                    viewModel.getDeliveryFees()
                }
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
            cell.items = viewModel.cart?.items ?? []
            
            cell.selectionStyle = .none
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodTableViewCell", for: indexPath) as? PaymentMethodTableViewCell else { return UITableViewCell()}
            
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryFeesTableViewCell", for: indexPath) as? DeliveryFeesTableViewCell else { return UITableViewCell()}
            cell.costLabel.text = "\(viewModel.deliveryFees?.cost ?? 0)"
            cell.expectedDeliveryTime.text = viewModel.deliveryFees?.expectedDeliveryTime
            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StorePaymentInfoTableViewCell", for: indexPath) as? StorePaymentInfoTableViewCell else { return UITableViewCell()}
            cell.subTotalLabel.text = viewModel.cart?.subtotal
            cell.deliveryValueLabel.text = viewModel.cart?.deliveryValue
            cell.taxLabel.text = viewModel.cart?.tax
            cell.totalLabel.text = viewModel.cart?.total
            return cell
            
        default:
            return UITableViewCell()
        }
       
    }
    
}
