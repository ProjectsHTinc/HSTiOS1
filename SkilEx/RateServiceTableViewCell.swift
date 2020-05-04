//
//  RateServiceTableViewCell.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 05/05/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit

class RateServiceTableViewCell: UITableViewCell {

    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var yesOutlet: UIButton!
    @IBOutlet weak var noOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
