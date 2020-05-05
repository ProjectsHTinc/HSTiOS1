//
//  ReviewData.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 05/05/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReviewData: Codable {
    
    var rating, service_id, review, customer_id, customer_name  : String?
    
    init(json:JSON) {
        
        self.rating = json["rating"].stringValue
        self.service_id = json["service_id"].stringValue
        self.review = json["review"].stringValue
        self.customer_id = json["customer_id"].stringValue
        self.customer_name = json["customer_name"].stringValue

    }

}
