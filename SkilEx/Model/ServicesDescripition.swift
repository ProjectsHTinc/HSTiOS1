//
//  ServicesDescripition.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 10/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class ServicesDescripition: Codable {
    
    var service_pic_url, exclusions_ta, is_advance_payment, service_ta_name, rate_card_details_ta, advance_amount, service_procedure, inclusions, service_name, sub_cat_id, others, exclusions, main_cat_id, service_procedure_ta, rate_card, service_id, others_ta, inclusions_ta, rate_card_details : String?
    
    init(json:JSON) {
        
        self.service_pic_url = json["service_pic_url"].stringValue
        self.exclusions_ta = json["exclusions_ta"].stringValue
        self.is_advance_payment = json["is_advance_payment"].stringValue
        self.service_ta_name = json["service_ta_name"].stringValue
        self.rate_card_details_ta = json["rate_card_details_ta"].stringValue
        self.advance_amount = json["advance_amount"].stringValue
        self.service_procedure = json["service_procedure"].stringValue
        self.inclusions = json["inclusions"].stringValue
        self.service_name = json["service_name"].stringValue
        self.sub_cat_id = json["sub_cat_id"].stringValue
        self.others = json["others"].stringValue
        self.exclusions = json["exclusions"].stringValue
        self.main_cat_id = json["main_cat_id"].stringValue
        self.service_procedure_ta = json["service_procedure_ta"].stringValue
        self.rate_card = json["rate_card"].stringValue
        self.service_id = json["service_id"].stringValue
        self.others_ta = json["others_ta"].stringValue
        self.inclusions_ta = json["inclusions_ta"].stringValue
        self.rate_card_details = json["rate_card_details"].stringValue

    }

}
