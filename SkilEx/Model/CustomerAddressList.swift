//
//  CustomerAddressList.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 07/12/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddressList: Codable {
    
    var contact_name, contact_no, customer_id, id, serv_address, serv_lat_lon, serv_loc : String?
    
    init(json:JSON) {
        
        self.contact_name = json["contact_name"].stringValue
        self.contact_no = json["contact_no"].stringValue
        self.customer_id = json["customer_id"].stringValue
        self.id = json["id"].stringValue
        self.serv_address = json["serv_address"].stringValue
        self.serv_lat_lon = json["serv_lat_lon"].stringValue
        self.serv_loc = json["serv_loc"].stringValue

    }
}
