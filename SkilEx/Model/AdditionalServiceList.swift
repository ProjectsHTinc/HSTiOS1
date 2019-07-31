//
//  AdditionalService.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 30/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class AdditionalServiceList: Codable {

    var service_name, id, service_pic, rate_card_details, rate_card_details_ta, rate_card, service_ta_name : String?
    
    init(json:JSON) {
        
        self.service_name = json["service_name"].stringValue
        self.id = json["id"].stringValue
        self.service_pic = json["service_pic"].stringValue
        self.rate_card_details = json["rate_card_details"].stringValue
        self.rate_card_details_ta = json["rate_card_details_ta"].stringValue
        self.rate_card = json["rate_card"].stringValue
        self.service_ta_name = json["service_ta_name"].stringValue

    }
}
