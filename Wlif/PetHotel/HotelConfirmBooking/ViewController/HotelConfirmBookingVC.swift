//
//  HotelConfirmBookingVC.swift
//  Wlif
//
//  Created by OSX on 31/07/2025.
//

import UIKit

class HotelConfirmBookingVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    
    let viewModel = HotelConfirmBookingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupTableView()
        bind()
        setupHeaderActions()
    }
    
    func setupTableView() {
        tableView.registerCell(cell: nameDetailsTableViewCell.self)
        tableView.registerCell(cell: HotelBookingSummaryCell.self)
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
    
    @IBAction func didTapContinueBtn(_ sender: Any) {
        viewModel.confirmHotelBooking { [weak self] result in
            switch result {
            case .success(_):
                let stoyboard = UIStoryboard(name: "VeterinaryServices", bundle: nil)
                let vc = stoyboard.instantiateViewController(withIdentifier: "ConfirmOrderVC") as! ConfirmOrderVC
                self?.navigationController?.pushViewController(vc, animated: true)
                
            case .failure(let error):
                print("Failed to add order: \(error.localizedDescription)")
            }
        }
    }
    

    
    @IBAction func didTapBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension HotelConfirmBookingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "nameDetailsTableViewCell", for: indexPath) as? nameDetailsTableViewCell else { return UITableViewCell()}
            cell.titleLabel.text = "About Hotel"
            cell.vetImageView.setImage(from: viewModel.bookingInfo?.store?.image)
            cell.nameLabel.text = viewModel.bookingInfo?.store?.name
            cell.locationLabel.text = viewModel.bookingInfo?.store?.distance
            cell.selectionStyle = .none
            return cell
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelBookingSummaryCell", for: indexPath) as? HotelBookingSummaryCell else { return UITableViewCell()}
            cell.entryDateLabel.text = viewModel.bookingInfo?.fromDate
            cell.exitDateLabel.text = viewModel.bookingInfo?.toDate
            cell.noOfAnimalsLabel.text = viewModel.bookingInfo?.noOfAnimals
            cell.noOfRoomsLabel.text = "1"
            cell.services = viewModel.bookingInfo?.services
            cell.selectionStyle = .none
            return cell
            
        case 2:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodTableViewCell", for: indexPath) as? PaymentMethodTableViewCell else { return UITableViewCell()}
            cell.selectionStyle = .none
            return cell
            
        case 3:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentInfoTableViewCell", for: indexPath) as? PaymentInfoTableViewCell,
                  let bookingInfo = viewModel.bookingInfo,
                  let roomPrice = bookingInfo.room?.price
            else {
                return UITableViewCell()
            }
            
            let servicesTotal = bookingInfo.services?.reduce(0, { $0 + ($1.price ?? 0) }) ?? 0
            let total = roomPrice + servicesTotal

            cell.subTotalLabel.text = "\(roomPrice) \("SR".localized)"
            cell.totalLabel.text = "\(total) \("SR".localized)"
            cell.selectionStyle = .none
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
