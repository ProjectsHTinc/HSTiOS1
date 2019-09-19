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
//        if let viewControllers = viewControllers {
//            selectedViewController = viewControllers[0]
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.preferedLanguage()
    }
    
    func preferedLanguage()
    {
        tabBar.items?[0].title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "hometab_text", comment: "")
        tabBar.items?[1].title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicetab_text", comment: "")
        tabBar.items?[2].title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "profiletab_text", comment: "")
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if(item.tag == 1)
        {
            // Code for item 1
            self.preferedLanguage()
        }
        else if(item.tag == 2) {
            // Code for item 2
            self.preferedLanguage()
        }
            
        else if(item.tag == 3) {
            // Code for item 3
            self.preferedLanguage()

        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
//        if (segue.identifier == "to_Login")
//        {
//            let _ = segue.destination as! Login
//        }
    }

}



