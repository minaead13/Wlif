//
//  nameDetailsTableViewCell.swift
//  Wlif
//
//  Created by OSX on 23/07/2025.
//

import UIKit

class nameDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var vetImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
