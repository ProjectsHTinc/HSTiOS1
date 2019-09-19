//
//  Bill.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 19/08/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class Bill: Codable {

    var id, file_bill : String?
    
    init(json:JSON) {
        
        self.id = json["id"].stringValue
        self.file_bill = json["file_bill"].stringValue
    }
}
