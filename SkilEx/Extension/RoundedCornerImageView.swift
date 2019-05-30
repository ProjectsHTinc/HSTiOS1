//
//  RoundedCornerImageView.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 20/05/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

extension UIImageView
{
    func makeRounded() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
    }
    
}
