//
//  VetsConfirmBookingVC.swift
//  Wlif
//
//  Created by OSX on 23/07/2025.
//

import UIKit

class VetsConfirmBookingVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = VetsConfirmBookingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupTableView()
        bind() 
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
            return cell
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceDataTableViewCell", for: indexPath) as? ServiceDataTableViewCell else { return UITableViewCell()}
            cell.serviceTypeLabel.text = viewModel.serviceType
            cell.dateLabel.text = viewModel.date
            cell.timeLabel.text = viewModel.selectedTime?.time
            cell.animalTypes = viewModel.selectedAnimalTypes
            
            return cell
            
        case 2:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodTableViewCell", for: indexPath) as? PaymentMethodTableViewCell else { return UITableViewCell()}
            
            return cell
            
        case 3:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentInfoTableViewCell", for: indexPath) as? PaymentInfoTableViewCell else { return UITableViewCell()}
            cell.totalLabel.text = "\(viewModel.category?.price ?? 0) \("SR".localized)"
            cell.subTotalLabel.text = "\(viewModel.category?.price ?? 0) \("SR".localized)"
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
