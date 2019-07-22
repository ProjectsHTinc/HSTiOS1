//
//  BannerImages.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 22/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class BannerImages: Codable {

    var id, banner_img: String?
    
    init(json:JSON) {
        
        self.id = json["id"].stringValue
        self.banner_img = json["banner_img"].stringValue
    }
}
