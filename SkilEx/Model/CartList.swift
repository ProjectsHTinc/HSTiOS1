//
//  CartList.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 22/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class CartList: Codable {
    
    var is_advance_payment, service_picture, status, rate_card, cart_id, advance_amount, service_name, service_ta_name : String?
    
    init(json:JSON) {
        
        self.is_advance_payment = json["is_advance_payment"].stringValue
        self.service_picture = json["service_picture"].stringValue
        self.status = json["status"].stringValue
        self.rate_card = json["rate_card"].stringValue
        self.cart_id = json["cart_id"].stringValue
        self.advance_amount = json["advance_amount"].stringValue
        self.service_name = json["service_name"].stringValue
        self.service_ta_name = json["service_ta_name"].stringValue

    }

}
