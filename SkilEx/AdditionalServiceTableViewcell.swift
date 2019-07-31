//
//  AdditionalServiceTableViewcell.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 30/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class AdditionalServiceTableViewcell: UITableViewCell {
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var rateCardDetails: UILabel!
    @IBOutlet weak var serviceCharge: UILabel!
    @IBOutlet weak var serviceImgView: UIImageView!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
