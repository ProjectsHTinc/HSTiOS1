//
//  CouponOffers.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 29/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class CouponOffers: Codable {

    var offer_code, offer_description, id, max_offer_amount, offer_title, offer_percent  : String?
    
    init(json:JSON) {
        
        self.offer_code = json["offer_code"].stringValue
        self.offer_description = json["offer_description"].stringValue
        self.id = json["id"].stringValue
        self.max_offer_amount = json["max_offer_amount"].stringValue
        self.offer_title = json["offer_title"].stringValue
        self.offer_percent = json["offer_percent"].stringValue
    }
}
