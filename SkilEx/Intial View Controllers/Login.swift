//
//  ViewController.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 03/05/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class Login: UIViewController {

    @IBOutlet var mobileNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.mobileNumber.delegate = self
        self.mobileNumber.tag = 1
        self.addToolBar(textField: mobileNumber)
        self.hideKeyboardWhenTappedAround()
    }

    @IBAction func submit(_ sender: Any)
    {
        self.webRequest(mobileNumber: self.mobileNumber.text!)
    }
    
    func webRequest (mobileNumber:String)
    {
        if mobileNumber.isEmpty{
            
            Alert.defaultManager.showOkAlert("SkilEx", message: "Mobile Number cannot be Empty") { (action) in
                //Custom action code
            }
    }
    else
    {
        let parameters = ["phone_no": mobileNumber]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "mobile_check", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let status = json["status"].stringValue
                        if msg == "Mobile OTP" && status == "success"{
                            let phone_no = json["phone_no"].stringValue
                            let otp = json["otp"].stringValue
                            let user_master_id = json["user_master_id"].stringValue
                            UserDefaults.standard.set(user_master_id, forKey: "user_master_id")
                            UserDefaults.standard.set(phone_no, forKey: "phone_no")
                            UserDefaults.standard.set(otp, forKey: "otp_key")
                            self.performSegue(withIdentifier: "to_OTP", sender: self)
                            print(phone_no)
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
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField.tag == 1
        {
            print("YES")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "to_OTP") {
            let vc = segue.destination as! OTP
            vc.user_msater_id = UserDefaults.standard.string(forKey: "user_master_id") ?? ""
            vc.mobileNumber = UserDefaults.standard.string(forKey: "mobileNumber") ?? ""
            vc.otp = UserDefaults.standard.string(forKey: "otp_key") ?? ""
            print(vc.user_msater_id,vc.otp)
        }
    }
    
}





