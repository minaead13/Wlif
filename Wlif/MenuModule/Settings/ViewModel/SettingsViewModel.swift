//
//  SettingsViewModel.swift
//  Wlif
//
//  Created by OSX on 05/08/2025.
//

import Foundation

class SettingsViewModel {
    
    var settingsArray = [
        SettingsModel(image: "OrderHistory", name: "Order History"),
        SettingsModel(image: "paymentMethod", name: "Payment Methods"),
        SettingsModel(image: "support", name: "Support"),
        SettingsModel(image: "language", name: "Language"),
        SettingsModel(image: "Terms", name: "Terms and Conditions"),
        SettingsModel(image: "ShareApp", name: "Share App"),
        SettingsModel(image: "Rate", name: "Rate App"),
        SettingsModel(image: "Wallet", name: "Wallet"),
        
    ]
    
    var profileArray = [
        SettingsModel(image: "PersonalInfo", name: "Personal Information"),
        SettingsModel(image: "ShippingAddress", name: "Shipping Address"),
        SettingsModel(image: "Logout", name: "Logout"),
        SettingsModel(image: "deleteAcc", name: "Delete Account")
    ]
}
