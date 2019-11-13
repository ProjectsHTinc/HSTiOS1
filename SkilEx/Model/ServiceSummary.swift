//
//  ServiceSummary.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 27/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class ServiceSummary: Codable {
    
    var person_number, additional_service_amt, service_order_id, provider_name, service_end_time, service_start_time, order_date, contact_person_number, paid_advance_amt, net_service_amount, material_notes, discount_amt, contact_person_name, time_slot, service_name, service_ta_name, person_name, payable_amount, total_service_cost, coupon_id, additional_service, service_amount, main_category, main_category_ta, sub_category, sub_category_ta, coupon_code : String?
    
    init(json:JSON)
    {
        self.person_number = json["person_number"].stringValue
        self.additional_service_amt = json["additional_service_amt"].stringValue
        self.service_order_id = json["service_order_id"].stringValue
        self.provider_name = json["provider_name"].stringValue
        self.service_end_time = json["service_end_time"].stringValue
        self.service_start_time = json["service_start_time"].stringValue
        self.order_date = json["order_date"].stringValue
        self.contact_person_number = json["contact_person_number"].stringValue
        self.order_date = json["order_date"].stringValue
        self.paid_advance_amt = json["paid_advance_amt"].stringValue
        self.net_service_amount = json["net_service_amount"].stringValue
        self.material_notes = json["material_notes"].stringValue
        self.discount_amt = json["discount_amt"].stringValue
        self.contact_person_name = json["contact_person_name"].stringValue
        self.time_slot = json["time_slot"].stringValue
        self.service_name = json["service_name"].stringValue
        self.service_ta_name = json["service_ta_name"].stringValue
        self.person_name = json["person_name"].stringValue
        self.payable_amount = json["payable_amount"].stringValue
        self.total_service_cost = json["total_service_cost"].stringValue
        self.coupon_id = json["coupon_id"].stringValue
        self.additional_service = json["additional_service"].stringValue
        self.service_amount = json["service_amount"].stringValue
        self.main_category = json["main_category"].stringValue
        self.main_category_ta = json["main_category_ta"].stringValue
        self.sub_category = json["sub_category"].stringValue
        self.sub_category_ta = json["sub_category_ta"].stringValue
        self.coupon_code = json["coupon_code"].stringValue
    }
}
