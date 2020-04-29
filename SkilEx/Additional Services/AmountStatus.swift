//
//  AmountStatus.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 28/04/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class AmountStatus: UIViewController {
    
    @IBOutlet weak var msgLabel: UILabel!
    var amount = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//      self.msgLabel.text = "Your amount ₹ \(amount) has been added to wallet successfully!!"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.preferedLanguage()
        self.addBackButton()
    }
    
    func preferedLanguage()
    {
        self.navigationItem.title =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "amountStatusnavtitle_text", comment: "")
    }
    
    @objc public override func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addMoneyToWallet (usermasterid:String)
    {
        let parameters = ["user_master_id": usermasterid]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.PaymentBaseUrl + "ccavenue_app/adding_money_to_wallet.php", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
//                      let msg_en = json["msg_en"].stringValue
//                      let msg_ta = json["msg_ta"].stringValue
                        let status = json["status"].stringValue
                        if  msg == "Can Claim" && status == "success"{
//                           let amount_to_be_claim = json["amount_to_be_claim"].stringValue
                        }
                        else
                        {
                            if LocalizationSystem.sharedInstance.getLanguage() == "en"
                            {
                                Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg) { (action) in
                                    //Custom action code
                                }
                            }
                            else
                            {
                                Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg) { (action) in
                                    //Custom action code
                                }
                            }
                        }
                    }) {
                        (error) -> Void in
                        print(error)
                    }
                }
                catch
                {
                    print("Unable to load data: \(error)")
                }
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

