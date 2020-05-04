//
//  TopTrendingServices.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 05/05/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class TopTrendingServices: Codable {

    var service_id, service_pic_url, main_cat_id, service_ta_name, service_name, sub_cat_id, selected  : String?
    
    init(json:JSON) {
        
        self.service_id = json["service_id"].stringValue
        self.service_pic_url = json["service_pic_url"].stringValue
        self.main_cat_id = json["main_cat_id"].stringValue
        self.service_ta_name = json["service_ta_name"].stringValue
        self.service_name = json["service_name"].stringValue
        self.sub_cat_id = json["sub_cat_id"].stringValue
        self.selected = json["selected"].stringValue

    }
    
}
