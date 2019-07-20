//
//  Tabbarcontroller.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 28/06/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class Tabbarcontroller: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
        if let viewControllers = viewControllers {
            selectedViewController = viewControllers[0]
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: (UITabBarItem?))
    {
        if item == self.tabBar.items! [2]
        {
            if GlobalVariables.shared.user_master_id == ""
            {
                let alertController = UIAlertController(title: "SkilEX", message: "If you want this service you have to login", preferredStyle: UIAlertController.Style.alert)
                
                
                let okAction = UIAlertAction(title: "Login", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.performSegue(withIdentifier: "to_Login", sender: self)
                    
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    
                    if let viewControllers = self.viewControllers {
                        self.selectedViewController = viewControllers[0]
                    }
                }
                
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "to_Login")
        {
            let _ = segue.destination as! Login
        }
    }

}
