//
//  BookingSuccess.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 26/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class BookingSuccess: UIViewController {
    @IBOutlet weak var succesLabel: UILabel!
    @IBOutlet weak var successStatusLabel: UILabel!
    @IBOutlet weak var backToHomeOutlet: UIButton!
    @IBOutlet weak var statusImg: UIImageView!
    
    var timer: Timer?
    var displayMinute = String()
    var transStatus = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.preferedLanguage()
        self.addBackButton()
        self.displayMinute = "1"
        
        let View =  UserDefaults.standard.string(forKey: "Advance/customer")

        if View == "CA"
        {
            self.statusImg.image = UIImage(named: "servicesuccess")
            self.succesLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "bookingsucces_text", comment: "")
            self.successStatusLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "bookingsuccesstatus_text", comment: "")
            self.backToHomeOutlet.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "backtohome_text", comment: ""), for: .normal)
        }
        else
        {
            if transStatus == "Transaction Successful"
            {
                self.statusImg.image = UIImage(named: "servicesuccess")
                self.succesLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "bookingsucces_text", comment: "")
                self.successStatusLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "bookingsuccesstatus_text", comment: "")
                self.backToHomeOutlet.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "backtohome_text", comment: ""), for: .normal)
                self.serviceProviderAllocation(user_master_id: GlobalVariables.shared.user_master_id, order_id: GlobalVariables.shared.order_id, displayMinute: self.displayMinute)
                self.WebRequesAdvanceamountbooking()
            }
            else
            {
                self.statusImg.image = UIImage(named: "cancelservice")
                self.succesLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "bookingfailed_text", comment: "")
                self.successStatusLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "bookingfailedstatus_text", comment: "")
                self.backToHomeOutlet.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "backtohomefailed_textt", comment: ""), for: .normal)
                self.WebRequesAdvanceamountbooking()
            }
        }
    }
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(callServiceAllocation), userInfo: nil, repeats: true);
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func callServiceAllocation()
    {
        self.serviceProviderAllocation(user_master_id: GlobalVariables.shared.user_master_id, order_id: GlobalVariables.shared.order_id, displayMinute: self.displayMinute)
    }
    
    override func viewWillLayoutSubviews() {
        backToHomeOutlet.addShadowToButton(color: UIColor.gray, cornerRadius: 20, backgroundcolor: UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0))
    }
    
    
    func preferedLanguage () {
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "bookingstatusnavtitle_text", comment: "")
        self.succesLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "bookingsucces_text", comment: "")
        self.successStatusLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "bookingsuccesstatus_text", comment: "")
        self.backToHomeOutlet.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "backtohome_text", comment: ""), for: .normal)
    }
    
    func serviceProviderAllocation(user_master_id: String, order_id: String, displayMinute: String)
    {
        let parameters = ["user_master_id": user_master_id, "order_id": order_id, "display_minute": displayMinute]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "service_provider_allocation", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let status = json["status"].stringValue
                        if msg == "Mobile OTP" && status == "success"
                        {
                            self.stopTimer()
                            Alert.defaultManager.showOkAlert("SkilEx", message: msg) { (action) in
//                                self.performSegue(withIdentifier: "home", sender: self)
                            }
                        }
                        else
                        {
                            if self.displayMinute == "1"
                            {
                                self.startTimer()
                                self.displayMinute = "2"
                            }
                            else if self.displayMinute == "2"
                            {
                                
                                self.displayMinute = "3"
                            }
                            else
                            {
                                self.stopTimer()
//                                self.performSegue(withIdentifier: "home", sender: self)
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
    
    func WebRequesAdvanceamountbooking ()
    {
        let parameters = ["order_id": GlobalVariables.shared.user_master_id, "advance_amount": GlobalVariables.shared.Advanceamount, "advance_payment_status": transStatus]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL("https://www.skilex.in/development/ccavenue_app/customer_advance.php", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let status = json["status"].stringValue
                        if msg == "Hitback" && status == "error"
                        {
                           print(msg)
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
    
   
    @objc public override func backButtonClick()
    {
        self.performSegue(withIdentifier: "toDashboard", sender: self)
    }
    
    @IBAction func backToHomeAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "toDashboard", sender: self)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "toDashboard")
        {
            let _ = segue.destination as! Tabbarcontroller
        }
    }
    

}
