//
//  Service.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 28/06/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class Service: UIViewController{
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewOne: UIView!
    @IBOutlet var viewTwo: UIView!
    @IBOutlet var viewThree: UIView!
    @IBOutlet var viewOneImgView: UIView!
    @IBOutlet var viewTwoImgView: UIView!
    @IBOutlet var viewThreeImgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "homenavtitle_text", comment: "")
    }
    
    @IBAction func requestServiceButtonAction(_ sender: Any)
    {
        
    }
    
    @IBAction func onGoingButtonAction(_ sender: Any)
    {
        
    }
    
    @IBAction func serviceHistoryButtonAction(_ sender: Any)
    {
        
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
