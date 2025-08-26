//
//  PetsStoresViewController.swift
//  Wlif
//
//  Created by OSX on 07/07/2025.
//

import UIKit

class PetsStoresViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = PetsStoresViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        setupTableView()
        bind()
        viewModel.getPetsStores()
    }
    
    func setupTableView() {
        tableView.registerCell(cell: PetsStoresTableViewCell.self)
    }
    
    func bind() {
        viewModel.onPetsStoresFetched = { [weak self] services in
            self?.tableView.reloadData()
        }
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension PetsStoresViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.petsStores?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PetsStoresTableViewCell", for: indexPath) as? PetsStoresTableViewCell else { return UITableViewCell() }
        
        if let data = viewModel.petsStores {
            cell.config(data: data[indexPath.row])
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StoreViewController") as! StoreViewController
        vc.viewModel.id = viewModel.petsStores![indexPath.row].id 
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
