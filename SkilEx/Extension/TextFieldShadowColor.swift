//
//  TextFieldShadowColor.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 27/06/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

extension UITextField {
    
    func addShadowToTextField(color: UIColor = UIColor.gray, cornerRadius: CGFloat) {
        
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1.0
        self.backgroundColor = .white
        self.layer.cornerRadius = cornerRadius
    }
}


