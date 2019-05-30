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
}

extension UserDefaults
{
    
    func saveDeviceToken(deviceToken: String)
    {
        set(deviceToken.isEmpty ? nil : deviceToken, forKey:UserDefaultsKey.userSessionKey.rawValue)
    }
    
    func getDevicetoken() -> String
    {
        return string(forKey: UserDefaultsKey.userSessionKey.rawValue)!
    }
    
    func saveUserdata(userdata: UserData)
    {
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userdata) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: UserDefaultsKey.userSessionKey.rawValue)
        }
    }
    
    func getUserData()-> UserData? {
    
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
    
    func clearUserData()
    {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.userSessionKey.rawValue)
    }
}
