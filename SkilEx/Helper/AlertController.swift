//
//  AlertController.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 19/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class AlertController: NSObject {
    
     static let shared: AlertController = AlertController()
     static let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()

    private override init() {
        
    }
    
    //MARK: ALERT
    
    func showAlertOnVC(targetVC: UIViewController,title: String,message: String){
        var message = message
        var title = title
        title = NSLocalizedString(title, comment: "")
        message = NSLocalizedString(message, comment: "")
        let alert = UIAlertController(title: title,message: message,preferredStyle:UIAlertController.Style.alert)
        let okButton = UIAlertAction(title:"OK",style: UIAlertAction.Style.default,handler:{
            (alert: UIAlertAction!)  in
        })
        alert.addAction(okButton)
        targetVC.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(targetVC: UIViewController,title: String,message: String, complition: @escaping ()->()){
        var message = message
        var title = title
        title = NSLocalizedString(title, comment: "")
        message = NSLocalizedString(message, comment: "")
        let alert = UIAlertController(title: title,message: message,preferredStyle:UIAlertController.Style.alert)
        let okButton = UIAlertAction(title:"OK",style: UIAlertAction.Style.default,handler:{
            (alert: UIAlertAction!)  in
            DispatchQueue.main.async {
                complition()
            }
        })
        alert.addAction(okButton)
        targetVC.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(aViewController: UIViewController, title aTitle: String, message aMessage: String, defaultButtonTitle aDefaultButtonTitle: String, aDefaultActionBlock: @escaping (_ action: UIAlertAction) -> Void, cancelButtonTitle aCancelButtonTitle: String, cancelActionBlock aCancelActionBlock: @escaping (_ action: UIAlertAction) -> Void) {
        let aAlertController = UIAlertController(title: aTitle, message: aMessage, preferredStyle: .alert)
        let aDefaultButtonAction = UIAlertAction(title: aDefaultButtonTitle, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            aDefaultActionBlock(action)
        });
        let aCancelButtonAction = UIAlertAction(title: aCancelButtonTitle, style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            aCancelActionBlock(action)
        })
        aAlertController.addAction(aDefaultButtonAction)
        aAlertController.addAction(aCancelButtonAction)
        aViewController.present(aAlertController, animated: true, completion: nil)
    }
    
    func showActionSheet(aViewController: UIViewController, title aTitle: String, message aMessage: String, defaultButtonTitle aDefaultButtonTitle: String, aDefaultActionBlock: @escaping (_ action: UIAlertAction) -> Void, cancelButtonTitle aCancelButtonTitle: String, cancelActionBlock aCancelActionBlock: @escaping (_ action: UIAlertAction) -> Void) {
        let aAlertController = UIAlertController(title: aTitle, message: aMessage, preferredStyle: .actionSheet)
        let aDefaultButtonAction = UIAlertAction(title: aDefaultButtonTitle, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            aDefaultActionBlock(action)
        });
        let aCancelButtonAction = UIAlertAction(title: aCancelButtonTitle, style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            aCancelActionBlock(action)
        })
        aAlertController.addAction(aDefaultButtonAction)
        aAlertController.addAction(aCancelButtonAction)
        aViewController.present(aAlertController, animated: true, completion: nil)
    }
    
    func showActionSheetSignleAction(aViewController: UIViewController, title aTitle: String, message aMessage: String, cancelButtonTitle aCancelButtonTitle: String, cancelActionBlock aCancelActionBlock: @escaping (_ action: UIAlertAction) -> Void) {
        let aAlertController = UIAlertController(title: aTitle, message: aMessage, preferredStyle: .actionSheet)
        let aCancelButtonAction = UIAlertAction(title: aCancelButtonTitle, style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            aCancelActionBlock(action)
        })
        aAlertController.addAction(aCancelButtonAction)
        aViewController.present(aAlertController, animated: true, completion: nil)
    }
}
