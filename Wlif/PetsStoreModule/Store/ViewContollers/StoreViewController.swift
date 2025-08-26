//
//  StoreViewController.swift
//  Wlif
//
//  Created by OSX on 07/07/2025.
//

import UIKit

class StoreViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = StoreViewModel()
    let cartViewModel = CartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        setupTableView()
        bind()
        viewModel.getStoreData()
    }
    

    func bind() {
        viewModel.onStoreFetched = { [weak self] services in
            self?.tableView.reloadData()
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
        
        cartViewModel.isLoading.bind { [weak self] isLoading in
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
    
    func setupTableView() {
        tableView.registerCell(cell: StoreDetailsTableViewCell.self)
        tableView.registerCell(cell: ProductTableViewCell.self)
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension StoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        case 1:
            return viewModel.store?.products?.count ?? 0
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StoreDetailsTableViewCell", for: indexPath) as? StoreDetailsTableViewCell else { return UITableViewCell() }
            
            if let data = viewModel.store?.store {
                cell.config(data: data)
            }
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
           
            if let data = viewModel.store?.products?[indexPath.row] {
                cell.config(data: data)
            }
            cell.updateQnty = { [weak self] action, qty in
                guard let self else { return }
                
                let productId = viewModel.store?.products?[indexPath.row].id ?? 0
                
                switch action {
                case .increase:
                    cartViewModel.addCartProduct(productId: productId, qty: qty)
                case .decrease:
                    print("minus")
                case .delete:
                    print("delete")
                }
            }
            
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            vc.viewModel.productId = viewModel.store?.products?[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
