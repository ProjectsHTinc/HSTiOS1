//
//  Toolbar.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 20/05/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

extension UIViewController
{
    func addToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        let doneButton = UIBarButtonItem(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "done", comment: ""), style: UIBarButtonItem.Style.done, target: self, action: #selector(donePressed(_:)))
        let cancelButton = UIBarButtonItem(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "cancel", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
//        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    @objc func donePressed(_ textField: UITextField)
    {
        view.endEditing(true)
    }
    
    @objc func cancelPressed(textField: UITextField)
    {
        view.endEditing(true) // or do something
    }
}
