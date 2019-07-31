//
//  Notifications.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 31/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class Notifications: Codable {

    var offer_code, offer_percent, offer_description, max_offer_amount, id, offer_title : String?
    
    init(json:JSON) {
        
        self.offer_code = json["offer_code"].stringValue
        self.offer_percent = json["offer_percent"].stringValue
        self.offer_description = json["offer_description"].stringValue
        self.max_offer_amount = json["max_offer_amount"].stringValue
        self.id = json["id"].stringValue
        self.offer_title = json["offer_title"].stringValue
        
    }
}
