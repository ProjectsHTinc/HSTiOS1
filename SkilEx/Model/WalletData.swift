//
//  WalletData.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 29/04/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class WalletData: Codable {

    var created_time, status, id, notes, created_date, transaction_amt : String?
       
       init(json:JSON) {
           
           self.created_time = json["created_time"].stringValue
           self.status = json["status"].stringValue
           self.id = json["id"].stringValue
           self.notes = json["notes"].stringValue
           self.created_date = json["created_date"].stringValue
           self.transaction_amt = json["transaction_amt"].stringValue
       }
}
