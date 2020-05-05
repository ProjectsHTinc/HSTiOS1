//
//  ReviewTableViewCell.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 05/05/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    @IBOutlet var nameText: UILabel!
    @IBOutlet var descripition: UILabel!
    @IBOutlet var imageOne: UIImageView!
    @IBOutlet var imageTwo: UIImageView!
    @IBOutlet var imageThree: UIImageView!
    @IBOutlet var imagefour: UIImageView!
    @IBOutlet var imageFive: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
