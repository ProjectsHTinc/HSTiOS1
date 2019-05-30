//
//  UserData.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 20/05/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserData: Codable {
    
    var fullName, userType, emailVerify, usermasterId, phoneNumber, profilePic, address, mobileVerify, email, gender : String?
    
    init(json:JSON) {
        
        self.address = json["address"].stringValue
        self.fullName = json["full_name"].stringValue
        self.userType = json["user_type"].stringValue
        self.emailVerify = json["email_verify"].stringValue
        self.usermasterId = json["user_master_id"].stringValue
        self.phoneNumber = json["phone_no"].stringValue
        self.profilePic = json["profile_pic"].stringValue
        self.address = json["address"].stringValue
        self.mobileVerify = json["mobile_verify"].stringValue
        self.email = json["email"].stringValue
        self.gender = json["gender"].stringValue
        
    }
}
