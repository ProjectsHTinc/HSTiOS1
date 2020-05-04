//
//  WalletDetailCell.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 28/04/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit

class WalletDetailCell: UITableViewCell {

    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var paidView: UIView!
    @IBOutlet weak var addAMountLabel: UILabel!
    @IBOutlet weak var addAmountTimeLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var paidAmountlabel: UILabel!
    @IBOutlet weak var paidAmountTimeLabel: UILabel!
    @IBOutlet weak var addAmount: UILabel!
    @IBOutlet weak var padiAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
