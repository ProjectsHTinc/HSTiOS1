//
//  ServicesListDetail.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 25/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class ServicesListDetail: Codable{

    var pic, service_name, estimated_cost, service_address, service_order_id, sub_category, time_slot, person_name, order_date, service_ta_name, main_category, contact_person_number, person_number, contact_person_name, sub_category_ta, provider_name, main_category_ta, order_status, person_id  : String?
    
    init(json:JSON) {
        
        self.pic = json["pic"].stringValue
        self.service_name = json["service_name"].stringValue
        self.estimated_cost = json["estimated_cost"].stringValue
        self.service_address = json["service_address"].stringValue
        self.service_order_id = json["service_order_id"].stringValue
        self.sub_category = json["sub_category"].stringValue
        self.time_slot = json["time_slot"].stringValue
        self.person_name = json["person_name"].stringValue
        self.order_date = json["order_date"].stringValue
        self.service_ta_name = json["service_ta_name"].stringValue
        self.main_category = json["main_category"].stringValue
        self.contact_person_number = json["contact_person_number"].stringValue
        self.person_number = json["person_number"].stringValue
        self.contact_person_name = json["contact_person_name"].stringValue
        self.sub_category_ta = json["sub_category_ta"].stringValue
        self.provider_name = json["provider_name"].stringValue
        self.main_category_ta = json["main_category_ta"].stringValue
        self.order_status = json["order_status"].stringValue
        self.person_id = json["person_id"].stringValue

    }

}
