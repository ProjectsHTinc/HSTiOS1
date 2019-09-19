//
//  ServiceDescripition.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 10/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class ServiceDescripition: UIViewController {
   
    @IBOutlet weak var servicePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addBackButton()
         self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicediscripitionnav_text", comment: "")
        let serviceDescripition = UserDefaults.standard.getServicesDescripition()
        let imgurl = serviceDescripition?.service_pic_url!
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if imgurl?.isEmpty == true
        {
            self.servicePicture.image = UIImage(named: "user.png")
        }
        else
        {

            let url = URL(string: imgurl!)
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self!.servicePicture.image = image
                            MBProgressHUD.hide(for: self!.view, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @objc public override func backButtonClick()
    {
        self.navigationController?.popViewController(animated: true)
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
