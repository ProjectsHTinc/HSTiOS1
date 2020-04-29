//
//  CCResultViewController.swift
//  CCIntegrationKit_Swift
//
//  Created by Ram Mhapasekar on 7/7/17.
//  Copyright © 2017 Ram Mhapasekar. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class CCResultViewController: UIViewController {

    var transStatus = String()
    var advancePayment = String()
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var subStatus: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var statusImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paybyCash = UserDefaults.standard.string(forKey: "PaybyCash")
        if (paybyCash == "YES")
        {
            self.backgroundView.backgroundColor = UIColor(red: 226/255.0, green: 242/255.0, blue: 240/255.0, alpha: 1.0)
            self.statusImg.image = UIImage(named: "success")
            self.statusLabel.textColor = UIColor(red: 63/255.0, green: 170/255.0, blue: 132/255.0, alpha: 1.0)
            self.subStatus.textColor = UIColor(red: 63/255.0, green: 170/255.0, blue: 132/255.0, alpha: 1.0)
            self.statusLabel.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "ccresultsucess_text", comment: "")
            self.subStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ccresultstatussuces_text", comment: "")
            self.doneButton.backgroundColor = UIColor(red: 63/255.0, green: 170/255.0, blue: 132/255.0, alpha: 1.0)
            self.doneButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "ccresultsbuttonsucess_text", comment: ""), for: .normal)
            self.servicePaymentSuccess(order_id: GlobalVariables.shared.order_id)
        }
        else
        {
            if transStatus == "Transaction Successful"
            {
               self.backgroundView.backgroundColor = UIColor(red: 226/255.0, green: 242/255.0, blue: 240/255.0, alpha: 1.0)
               self.statusImg.image = UIImage(named: "success")
               self.statusLabel.textColor = UIColor(red: 63/255.0, green: 170/255.0, blue: 132/255.0, alpha: 1.0)
               self.subStatus.textColor = UIColor(red: 63/255.0, green: 170/255.0, blue: 132/255.0, alpha: 1.0)
               self.statusLabel.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "ccresultsucess_text", comment: "")
               self.subStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ccresultstatussuces_text", comment: "")
               self.doneButton.backgroundColor = UIColor(red: 63/255.0, green: 170/255.0, blue: 132/255.0, alpha: 1.0)
               self.doneButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "ccresultsbuttonsucess_text", comment: ""), for: .normal)
               self.servicePaymentSuccess(order_id: GlobalVariables.shared.order_id)

            }
           else
           {
               self.backgroundView.backgroundColor = UIColor(red: 251/255.0, green: 242/255.0, blue: 236/255.0, alpha: 1.0)
               self.statusImg.image = UIImage(named: "failed")
               self.statusLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ccresultfailure_text", comment: "")
               self.statusLabel.textColor = UIColor(red: 239/255.0, green: 64/255.0, blue: 105/255.0, alpha: 1.0)
               self.subStatus.textColor = UIColor(red: 239/255.0, green: 64/255.0, blue: 105/255.0, alpha: 1.0)
               self.subStatus.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ccresultstatusfailure_text", comment: "")
               self.doneButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "ccresultsbuttonfailure_text", comment: ""), for: .normal)
               self.doneButton.backgroundColor = UIColor(red: 239/255.0, green: 64/255.0, blue: 105/255.0, alpha: 1.0)

           }
        }
    }
    
    override func viewWillLayoutSubviews() {
        doneButton.addShadowToButton(color: UIColor.gray, cornerRadius: 20, backgroundcolor: UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(transStatus)
    }
    
    @IBAction func doneAction(_ sender: Any)
    {
        let paybyCash = UserDefaults.standard.string(forKey: "PaybyCash")
        if transStatus == "Transaction Successful"
        {
            self.performSegue(withIdentifier: "rateService", sender: self)
        }
        else if (paybyCash == "YES")
        {
            self.performSegue(withIdentifier: "rateService", sender: self)
        }
        else
        {
            self.performSegue(withIdentifier: "home", sender: self)
        }
    }
    
    func servicePaymentSuccess(order_id:String)
    {
        let parameters = ["order_id":order_id]
//                  MBProgressHUD.showAdded(to: self.view, animated: true)
                  DispatchQueue.global().async
                      {
                          do
                          {
                              try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "service_payment_success", params: (parameters ), headers: nil, success:
                              {
                                  (JSONResponse) -> Void in
//                                  MBProgressHUD.hide(for: self.view, animated: true)
//                                  let json = JSON(JSONResponse)
//                                  let msg = json["msg"].stringValue
//                                  let msg_en = json["msg_en"].stringValue
//                                  let msg_ta = json["msg_ta"].stringValue
//                                  let status = json["status"].stringValue
//                                  if msg == "Login Successfully" && status == "success"
//                                  {
//
//                                  }
//                                  else
//                                  {
//
//                                  }
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
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "home") {
            let _ = segue.destination as! Tabbarcontroller
        }
        else if (segue.identifier == "rateService"){
            let _ = segue.destination as! RateServiceViewController

        }
    }
}

