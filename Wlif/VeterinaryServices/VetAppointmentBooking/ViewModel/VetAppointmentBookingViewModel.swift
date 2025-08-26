//
//  VetAppointmentBooking.swift
//  Wlif
//
//  Created by OSX on 21/07/2025.
//

import Foundation

class VetAppointmentBooking {
    var id: Int?
    
    var categoryDetails: VetAppointmentModel? {
        didSet {
            self.onCategoryDetailsFetched?(categoryDetails)
        }
    }
    
    var onCategoryDetailsFetched: ((VetAppointmentModel?) -> Void)?
    
    func getCategoryDetails(completion: ((Result<VetAppointmentModel, Error>) -> Void)? = nil) {
                
        let url = Urls.category + "/\(id ?? 0)"
        NetworkManager.instance.request(url, parameters: nil, method: .get, type: VetAppointmentModel.self) { [weak self] (baseModel, error) in
                        
            if let data = baseModel?.data {
                self?.categoryDetails = data
            }
        }
    }
}
