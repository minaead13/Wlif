//
//  LocationViewModel.swift
//  Fleen
//
//  Created by Mina Eid on 07/02/2024.
//

import UIKit

class LocationViewModel{
    
    var isLoading : Observable<Bool> = Observable(false)
    
    var saved: Int?
    var address_type : Int?
    var address : String?
    var lon : Float?
    var lat : Float?
    var default_address : String?
    
    func sendLocation(viewController : UIViewController, lat : Float, lon : Float, saved: Int, address_type: Int, address: String ,default_address : String  ,successCallback: (() -> Void)? = nil ) {
        
        self.isLoading.value = true
        let parameters: [String: Any] = [
            
            "lat": lat,
            "lon" : lon,
            "saved" : saved,
            "address_type" : address_type,
            "address" : address ,
            "default_address" : default_address
        ]
        
        
        NetworkManager.instance.request(Endpoints.addLocationURL, parameters: parameters, method: .post, type: addToCart.self, viewController: viewController) { [weak self] (data) in
          
            self?.successData(data: data, successCallback: successCallback)
            
        }
    }
    
    private func successData(data: BaseModel<addToCart>?,  successCallback: (() -> Void)? ) {
        if data != nil {
            successCallback?()
            self.isLoading.value = false
            print(data)
        } else {
            self.isLoading.value = false
            if let message = data?.message {
                //self.swiftMessage(title: "Error", body: message, color: .error, layout: .messageView, style: .bottom)
                
            }
        }
    }
    
}
