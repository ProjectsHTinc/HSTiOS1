//
//  Tabbarcontroller.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 28/06/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class Tabbarcontroller: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let viewControllers = viewControllers {
            selectedViewController = viewControllers[0]
        }
        

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
