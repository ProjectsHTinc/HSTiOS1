//
//  OngoingServiceTableViewCell.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 23/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class OngoingServiceTableViewCell: UITableViewCell {
    @IBOutlet weak var mainCategoery: UILabel!
    @IBOutlet weak var subCategoery: UILabel!
    @IBOutlet weak var serviceDate: UILabel!
    @IBOutlet weak var customerName: UILabel!
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
