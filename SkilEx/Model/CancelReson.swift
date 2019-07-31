//
//  CancelReson.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 30/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class CancelReson: Codable {
    
    var cancel_reason, id : String?
    
    init(json:JSON) {
        
        self.cancel_reason = json["cancel_reason"].stringValue
        self.id = json["id"].stringValue
    }

}
