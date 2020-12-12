//
//  ChooseAddressCell.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 07/12/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit

class ChooseAddressCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var custNameLabel: UILabel!
    @IBOutlet weak var CustAddressLabel: UILabel!
    @IBOutlet weak var custphoneNoLabel: UILabel!
    @IBOutlet weak var custCityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
