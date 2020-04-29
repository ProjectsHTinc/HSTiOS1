//
//  UserDafault.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 20/05/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

enum UserDefaultsKey : String
{
      case userSessionKey
      case userDeviceTokenKey
}

extension UserDefaults
{
    
    func saveDeviceToken(deviceToken: String)
    {
        set(deviceToken.isEmpty ? nil : deviceToken, forKey:UserDefaultsKey.userDeviceTokenKey.rawValue)
    }
    
    func getDevicetoken() -> String
    {
        return string(forKey: UserDefaultsKey.userDeviceTokenKey.rawValue)!
    }
    
    func saveUserdata(userdata: UserData)
    {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userdata) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: UserDefaultsKey.userSessionKey.rawValue)
        }
    }
    
    func getUserData()-> UserData?
    {
    
        if data(forKey: UserDefaultsKey.userSessionKey.rawValue) != nil
        {
            let decodedData = UserDefaults.standard.data(forKey: UserDefaultsKey.userSessionKey.rawValue)
            var Userdata: UserData?
            if decodedData != nil {
                Userdata = try! JSONDecoder().decode(UserData.self, from: decodedData!)
            }
            return Userdata
        }
        
        return nil
    }
    
    func saveServicesDescripition(servicesDescripition: ServicesDescripition)
    {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(servicesDescripition) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: UserDefaultsKey.userSessionKey.rawValue)
        }
    }
    
    func getServicesDescripition()-> ServicesDescripition? {
        
        if data(forKey: UserDefaultsKey.userSessionKey.rawValue) != nil
        {
            let decodedData = UserDefaults.standard.data(forKey: UserDefaultsKey.userSessionKey.rawValue)
            var servicesdescripition: ServicesDescripition?
            if decodedData != nil
            {
                servicesdescripition = try! JSONDecoder().decode(ServicesDescripition.self, from: decodedData!)
            }
            return servicesdescripition
        }
        
        return nil
    }
    
    func saveServicesDetail(servicesListDetail: ServicesListDetail)
    {
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(servicesListDetail)
        {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: UserDefaultsKey.userSessionKey.rawValue)
        }
    }
    
    func getServicesDetail()-> ServicesListDetail?
    {
        
        if data(forKey: UserDefaultsKey.userSessionKey.rawValue) != nil
        {
            let decodedData = UserDefaults.standard.data(forKey: UserDefaultsKey.userSessionKey.rawValue)
            var servicesdetail: ServicesListDetail?
            if decodedData != nil {
                servicesdetail = try! JSONDecoder().decode(ServicesListDetail.self, from: decodedData!)
            }
            return servicesdetail
        }
        
        return nil
    }
    
    func saveServiceSummary(serviceSummary: ServiceSummary)
    {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(serviceSummary) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: UserDefaultsKey.userSessionKey.rawValue)
        }
    }
    
    func getServiceSummary()-> ServiceSummary?
    {
        if data(forKey: UserDefaultsKey.userSessionKey.rawValue) != nil
        {
            let decodedData = UserDefaults.standard.data(forKey: UserDefaultsKey.userSessionKey.rawValue)
            var service_Summary: ServiceSummary?
            if decodedData != nil {
                service_Summary = try! JSONDecoder().decode(ServiceSummary.self, from: decodedData!)
            }
            return service_Summary
        }
        
        return nil
    }
    
    func saveWalletData(walletData: WalletData)
    {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(walletData) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: UserDefaultsKey.userSessionKey.rawValue)
        }
    }
    
    func getWalletData()-> WalletData?
    {
        if data(forKey: UserDefaultsKey.userSessionKey.rawValue) != nil
        {
            let decodedData = UserDefaults.standard.data(forKey: UserDefaultsKey.userSessionKey.rawValue)
            var Wallet_Data: WalletData?
            if decodedData != nil {
                Wallet_Data = try! JSONDecoder().decode(WalletData.self, from: decodedData!)
            }
            return Wallet_Data
        }
        
        return nil
    }
    
    func clearUserData()
    {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.userSessionKey.rawValue)
    }
}
