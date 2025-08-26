//
//  CartViewModel.swift
//  Wlif
//
//  Created by OSX on 09/07/2025.
//

import Foundation

class CartViewModel {
    
    
    func addCartProduct(productId: Int, qty: Int, completion: ((Result<StoreModel, Error>) -> Void)? = nil) {
        
        let params = [
            "product_id" : productId,
            "qty": qty
        ] as [String: Any]
        
        NetworkManager.instance.request(Urls.storeCart, parameters: params, method: .post, type: StoreModel.self) { [weak self] (baseModel, error) in
            
        }
    }
    
    func minusCartProduct(productId: Int, qty: Int, completion: ((Result<StoreModel, Error>) -> Void)? = nil) {
        
        let url = Urls.cartUpdate + "/\(productId)"
        let params = [
            "qty": qty
        ] as [String: Any]
        
        NetworkManager.instance.request(url, parameters: params, method: .post, type: StoreModel.self) { [weak self] (baseModel, error) in
            
        }
    }
}
