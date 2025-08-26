//
//  HeaderTableViewCell.swift
//  Wlif
//
//  Created by OSX on 02/07/2025.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var handleCartSelection: (() -> Void)?
    var handleMenuSelection: (() -> Void)?
    
    var banners: [BannerModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
        nameLabel.text = "\("Hi".localized) \(UserUtil.load()?.user.name ?? "")"
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(cell: BannerTableViewCell.self)
    }

    @IBAction func didTapCartBtn(_ sender: Any) {
        handleCartSelection?()
    }
    
    @IBAction func didTapMenuBtn(_ sender: Any) {
        handleMenuSelection?()
    }
}

extension HeaderTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return banners.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell", for: indexPath) as? BannerTableViewCell else { return UITableViewCell() }
        
        cell.banners = banners
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 171
    }
}
