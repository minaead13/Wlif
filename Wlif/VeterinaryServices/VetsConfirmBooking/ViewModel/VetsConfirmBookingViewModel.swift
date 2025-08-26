//
//  VetsConfirmBookingViewModel.swift
//  Wlif
//
//  Created by OSX on 23/07/2025.
//

import Foundation

class VetsConfirmBookingViewModel {
    
    var store: Store?
    var selectedAnimalTypes: [AnimalType] = []
    var selectedTime: TimeSlot?
    var serviceType: String?
    var date: String?
    var category: Category?
    var serviceID: Int?
    var isLoading: Observable<Bool> = Observable(false)

    func addVetOrder(completion: ((Result<VetAppointmentModel, Error>) -> Void)? = nil) {
        self.isLoading.value = true

        let params = [
            "merchant_id": "\(serviceID ?? 0)",
            "category_id": "\(category?.id ?? 0)",
            "date": "\(date?.toBackendDateFormat() ?? "")",
            "animal_types": selectedAnimalTypes.compactMap { $0.id },
            "time_slot_id": "\(selectedTime?.id ?? 0)",
            "payment_type": "1"
        ] as [String: Any]
        
                
        NetworkManager.instance.request(Urls.bookingStore, parameters: params, method: .post, type: VetAppointmentModel.self) { [weak self] (baseModel, message) in
            self?.isLoading.value = false

            if let data = baseModel?.data {
                completion?(.success(data))
            } else {
                completion?(.failure(ErrorHelper.makeError(message ?? "Unknown error")))
            }
        }
    }
}
