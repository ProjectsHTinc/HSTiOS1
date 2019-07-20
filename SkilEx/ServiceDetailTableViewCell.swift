//
//  ServiceDetailTableViewCell.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 04/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class ServiceDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var tickImage: UIImageView!
    @IBOutlet weak var selectionBackgroundView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addLabel: UILabel!
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
