//
//  Categories.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 03/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class Categories: Codable {
    
    var cat_id, cat_name, cat_pic_url, cat_ta_name : String?
    
    init(json:JSON) {
        
        self.cat_id = json["cat_id"].stringValue
        self.cat_name = json["cat_name"].stringValue
        self.cat_pic_url = json["cat_pic_url"].stringValue
        self.cat_ta_name = json["cat_ta_name"].stringValue
    }

}
