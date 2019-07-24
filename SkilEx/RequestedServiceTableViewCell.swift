//
//  RequestedServiceTableViewCell.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 24/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class RequestedServiceTableViewCell: UITableViewCell {
    @IBOutlet weak var mainCatgoery: UILabel!
    @IBOutlet weak var subcatgoery: UILabel!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
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
