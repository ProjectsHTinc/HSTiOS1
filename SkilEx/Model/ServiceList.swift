//
//  ServiceList.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 23/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class ServiceList: Codable {

    var service_order_id, service_ta_name, order_date, time_slot, sub_category, main_category, service_name, main_category_ta, sub_category_ta, contact_person_name, order_status : String?
    
    init(json:JSON) {
        
        self.service_order_id = json["service_order_id"].stringValue
        self.service_ta_name = json["service_ta_name"].stringValue
        self.order_date = json["order_date"].stringValue
        self.time_slot = json["time_slot"].stringValue
        self.sub_category = json["sub_category"].stringValue
        self.main_category = json["main_category"].stringValue
        self.service_name = json["service_name"].stringValue
        self.main_category_ta = json["main_category_ta"].stringValue
        self.sub_category_ta = json["sub_category_ta"].stringValue
        self.contact_person_name = json["contact_person_name"].stringValue
        self.order_status = json["order_status"].stringValue

    }
}
