//
//  SubCategories.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 08/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class SubCategories: Codable {
    
    var main_cat_id, sub_cat_pic_url, sub_cat_name, sub_cat_id, sub_cat_ta_name : String?
    
    init(json:JSON) {
        
        self.main_cat_id = json["main_cat_id"].stringValue
        self.sub_cat_pic_url = json["sub_cat_pic_url"].stringValue
        self.sub_cat_name = json["sub_cat_name"].stringValue
        self.sub_cat_id = json["sub_cat_id"].stringValue
        self.sub_cat_ta_name = json["sub_cat_ta_name"].stringValue

    }


}
