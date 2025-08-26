//
//  StoreViewModel.swift
//  Wlif
//
//  Created by OSX on 07/07/2025.
//

import Foundation

class StoreViewModel {
    var id: Int?
    var isLoading: Observable<Bool> = Observable(false)

    var store: StoreModel? {
        didSet {
            self.onStoreFetched?(store)
        }
    }
    
    var onStoreFetched: ((StoreModel?) -> Void)?
    
    func getStoreData(completion: ((Result<StoreModel, Error>) -> Void)? = nil) {
        self.isLoading.value = true

        let url = Urls.store + "/\(id ?? 0)"
        NetworkManager.instance.request(url, parameters: nil, method: .get, type: StoreModel.self) { [weak self] (baseModel, error) in
            self?.isLoading.value = false

            if let data = baseModel?.data {
                self?.store = data
            }
        }
    }
}
