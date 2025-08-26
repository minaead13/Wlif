//
//  HotelConfirmBookingViewModel.swift
//  Wlif
//
//  Created by OSX on 31/07/2025.
//

import Foundation

class HotelConfirmBookingViewModel {
    var bookingInfo: HotelBookingInfo?
    
    var isLoading: Observable<Bool> = Observable(false)
    
    func confirmHotelBooking(completion: ((Result<VetAppointmentModel, Error>) -> Void)? = nil) {
        self.isLoading.value = true
        
        let params = [
            "merchant_id": "\(bookingInfo?.hotelId ?? 0)",
            "date": "\(bookingInfo?.fromDate ?? "")",
            "rooms_number": "\(bookingInfo?.room?.id ?? 0)",
            "animals_number": "\(bookingInfo?.noOfAnimals ?? "")",
            "category_ids": bookingInfo?.services?.compactMap { $0.id} ?? [],
            "payment_type": "1"
        ] as [String: Any]
        
        
        NetworkManager.instance.request(Urls.petHotelBooking, parameters: params, method: .post, type: VetAppointmentModel.self) { [weak self] (baseModel, message) in
            self?.isLoading.value = false
            
            if let data = baseModel?.data {
                completion?(.success(data))
            } else {
                completion?(.failure(ErrorHelper.makeError(message ?? "Unknown error")))
            }
        }
    }
}
