//
//  ProductDetailsViewModel.swift
//  Wlif
//
//  Created by OSX on 09/07/2025.
//

import Foundation

class ProductDetailsViewModel {
    
    var productId: Int?
    
    var productDetails: ProcutDetailsModel? {
        didSet {
            self.onproductDetailsFetched?(productDetails)
        }
    }
    
    var onproductDetailsFetched: ((ProcutDetailsModel?) -> Void)?
    
    func getProductDetails(completion: ((Result<ProcutDetailsModel, Error>) -> Void)? = nil) {
        
        let url = Urls.product + "/\(productId ?? 0)"
        
        NetworkManager.instance.request(url, parameters: nil, method: .get, type: ProcutDetailsModel.self) { [weak self] (baseModel, error) in
            
            if let data = baseModel?.data {
                self?.productDetails = data
            }
        }
    }
    
}
