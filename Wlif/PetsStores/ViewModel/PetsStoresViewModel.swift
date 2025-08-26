//
//  PetsStoresViewModel.swift
//  Wlif
//
//  Created by OSX on 07/07/2025.
//

import Foundation

class PetsStoresViewModel {
    
    var petsStores: [PetsStoresModel]? {
        didSet {
            self.onPetsStoresFetched?(petsStores)
        }
    }
    
    var onPetsStoresFetched: (([PetsStoresModel]?) -> Void)?
    
    func getPetsStores(completion: ((Result<[PetsStoresModel], Error>) -> Void)? = nil) {
                
        NetworkManager.instance.request(Urls.storesList, parameters: nil, method: .get, type: [PetsStoresModel].self) { [weak self] (baseModel, error) in
                        
            if let data = baseModel?.data {
                self?.petsStores = data
            }
        }
    }
}
