//
//  AllOffersViewController.swift
//  Wlif
//
//  Created by OSX on 14/08/2025.
//

import UIKit

class AllOffersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = OffersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        setTableView()
        bind()
        viewModel.getOffers()
    }
    
    func setTableView() {
        tableView.registerCell(cell: StoreOffersTableViewCell.self)
        tableView.registerCell(cell: ClinicsOffersTableViewCell.self)
        
    }
    @IBAction func didTapBackBtn(_ sender: Any) {
        
    }
    

}
