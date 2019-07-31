//
//  ServiceHistoryTableViewCell.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 27/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class ServiceHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var mainCategoery: UILabel!
    @IBOutlet weak var subcategoery: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var serviceStatusImage: UIImageView!
    @IBOutlet weak var serviceStats: UILabel!
    @IBOutlet weak var starIconOne: UIImageView!
    @IBOutlet weak var starIconTwo: UIImageView!
    @IBOutlet weak var starIconThree: UIImageView!
    @IBOutlet weak var starIconFour: UIImageView!
    @IBOutlet weak var starIconFive: UIImageView!
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
