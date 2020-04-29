//
//  TermsandConditionCell.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 18/12/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class TermsandConditionCell: UITableViewCell {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var descripitionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
