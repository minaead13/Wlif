//
//  StorePaymentInfoTableViewCell.swift
//  Wlif
//
//  Created by OSX on 03/08/2025.
//

import UIKit

class StorePaymentInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var deliveryValueLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
