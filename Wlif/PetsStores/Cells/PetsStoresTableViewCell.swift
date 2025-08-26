//
//  ServiceDetailsTableViewCell.swift
//  Wlif
//
//  Created by OSX on 07/07/2025.
//

import UIKit

class PetsStoresTableViewCell: UITableViewCell {
    
    @IBOutlet weak var petsStoreImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func config(data: PetsStoresModel) {
        if let url = URL(string: data.image) {
            petsStoreImageView.kf.setImage(with: url)
        }
        self.nameLabel.text = data.name
        self.descLabel.text = data.shortDesc
        self.deliveryLabel.text = data.delivery
        self.distanceLabel.text = data.distance
    }
    
}
