//
//  FeedBackQuestions.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 05/05/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class FeedBackQuestions: Codable {

    var feedback_question, id : String?
       
       init(json:JSON) {
           self.feedback_question = json["feedback_question"].stringValue
           self.id = json["id"].stringValue
       }
}
