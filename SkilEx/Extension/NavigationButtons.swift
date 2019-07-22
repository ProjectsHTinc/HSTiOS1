//
//  NavigationButtons.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 22/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

extension UIViewController
{
    func addBackButton()
    {
        //Back buttion
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: "back"), for: UIControl.State())
        btnLeftMenu.addTarget(self, action: #selector(backButtonClick), for: UIControl.Event.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 33/2, height: 27/2)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc public func backButtonClick()
    {
        
    }
    
    func addrightButton()
    {
        //Back buttion
        let btnRighttMenu: UIButton = UIButton()
        btnRighttMenu.setImage(UIImage(named: "notification"), for: UIControl.State())
        btnRighttMenu.addTarget(self, action: #selector(rightButtonClick), for: UIControl.Event.touchUpInside)
        btnRighttMenu.frame = CGRect(x: 0, y: 0, width: 33/2, height: 27/2)
        let barButton = UIBarButtonItem(customView: btnRighttMenu)
        self.navigationItem.rightBarButtonItem  = barButton
    }
    
    @objc public func rightButtonClick()
    {
        
    }
}
