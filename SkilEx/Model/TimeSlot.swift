//
//  TimeSlot.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 16/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class TimeSlot: Codable {
    
    var time_range, timeslot_id : String?
    
    init(json:JSON) {
        
        self.time_range = json["time_range"].stringValue
        self.timeslot_id = json["timeslot_id"].stringValue
    }

}
