//
//  AdvancePayment.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 18/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON

class AdvancePayment: UIViewController {
    
    var advance_amount = String()
    var orderId = String()
    
    @IBOutlet weak var advancepaymentLabel: UILabel!
    @IBOutlet weak var advanceAmount: UILabel!
    @IBOutlet weak var proceedOutlet: UIButton!
    @IBOutlet weak var subView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addBackButton()
        self.advanceAmount.text = String(format: "%@ %@", "Rs.", advance_amount)
        self.preferedLanguage()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.preferedLanguage()
    }
    
    override func viewWillLayoutSubviews() {
        
        self.subView.dropShadow(offsetX: 0, offsetY: 1, color: UIColor.gray, opacity: 0.5, radius: 6)
        proceedOutlet.addShadowToButton(color: UIColor.gray, cornerRadius: 18, backgroundcolor: UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0))
    }
    
    @objc public override func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func preferedLanguage()
    {
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "advancepaymentnavtitle_text", comment: "")
        proceedOutlet.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "advancepaymentproceed_text", comment: ""), for: .normal)
    }
    
    @IBAction func proceedAction(_ sender: Any)
    {
        self.webRequestCCavenue ()
    }
    
    
    func webRequestCCavenue ()
    {
        UserDefaults.standard.set("Ap", forKey: "Advance/customer")
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "CCWebViewController") as! CCWebViewController
        viewController.accessCode = "AVQM86GG76CA98MQAC"
        viewController.merchantId = "225068"
        viewController.amount = "1.00"
            // advance_amount
        viewController.currency = "INR"
        viewController.orderId = GlobalVariables.shared.order_id
        viewController.redirectUrl = "https://www.skilex.in/development/ccavenue_app/customer_advance.php"
        viewController.cancelUrl = "https://www.skilex.in/development/ccavenue_app/customer_advance.php"
        viewController.rsaKeyUrl = "https://www.skilex.in/development/ccavenue_app/GetRSA.php"
        self.present(viewController, animated: true, completion: nil)
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
