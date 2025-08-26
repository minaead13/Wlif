//
//  AdoptionDetailsTableViewCell.swift
//  Wlif
//
//  Created by OSX on 13/07/2025.
//

import UIKit

class AdoptionDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var bloodTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(data: AdoptionDetailsModel) {
        petNameLabel.text = data.petName
        descLabel.text = data.distance
        distanceLabel.text = data.distance
        ageLabel.text = data.age
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapCommunicateBtn(_ sender: Any) {
    }
    
}
