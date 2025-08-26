//
//  LocationUtil.swift
//  Chefaa
//
//  Created by Chefaa on 1/27/20.
//  Copyright © 2020 Abdelrahman Eldesoky. All rights reserved.
//

import SwiftyJSON
import RxCocoa
import RxSwift

class LocationUtil {
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
    static let ArchiveURL = DocumentsDirectory?.appendingPathComponent("location")
//    static let AutofillArchiveURL = DocumentsDirectory.appendingPathComponent("autofill_location")
    
    static func save(_ item: Location?) {
        if let item {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: item, requiringSecureCoding: false)
                if let ArchiveURL {
                    try data.write(to: ArchiveURL)
                }
            } catch {
                print("Couldn't read file.")
            }
        }
    }
    
    static func delete() {
        do {
            if let ArchiveURL {
                try FileManager.default.removeItem(at: ArchiveURL)
            }
            UserDefaults.standard.removeObject(forKey: "zoneId")
        } catch {
            print("Couldn't delete file: \(error.localizedDescription)")
        }
    }
    
    static func load() -> Location? {
        guard let ArchiveURL else { return nil }
        if let nsData = NSData(contentsOf: ArchiveURL) {
            do {
                
                let data = Data(referencing:nsData)
                
                if let loaded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Location {
                    return loaded
                }
            } catch {
                print("Couldn't read file.")
                return nil
            }
        }
        return nil
        
    }
    
    static func isActive() -> Bool {
        if let location =  LocationUtil.load() , location.area != nil && location.city != nil {
            return true
        }
        return false
    }
    
    static func getSplittedCity() -> String {
        if let location = LocationUtil.load() , LocationUtil.isActive(){
            let city = location.city ?? ""
            return city
                .replacingOccurrences(of: "محافظة", with: "")
                .replacingOccurrences(of: "Governorate", with: "")
        }else{
            return ""
        }
    }
    
    static func getDataFor(_ address:Address?) -> [String:Any]  {
    
        return [
            "title":address?.title?.locale ?? "",
            "latitude":"\(address?.latitude ?? 0)",
            "longitude":"\(address?.longitude ?? 0)",
            "city":address?.city?.name ?? "",
            "area":address?.area?.name ?? "",
            "cityId":address?.city?.id ?? 0,
            "areaId":address?.area?.id ?? 0,
            "addressId":address?.id ?? 0,
            "address":address?.address ?? "",
            "building_no":address?.building ?? "",
            "is_online_payment_allowed":address?.isOnlinePaymentAllowed ?? "",
        ]
    }
    
    static func loadAddressess() -> Observable<JSON>  {
        
        let loading = BehaviorRelay<Bool>(value: false)
        
        return RequestHandler.shared.observableRequest(
            link: Urls.addresses,
            method: .get,
            parameters: [:],
            loading:loading)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .catchError({ (error) -> Observable<Results> in
                return Observable.empty()
            })
            .map { (result) -> JSON in
                if let value = result.data {
                    return value["data"]
                }else{
                    return JSON([])
                }
        }
        
    }

}
