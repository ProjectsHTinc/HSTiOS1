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

class Login: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var enterMobileNumberLabel: UILabel!
    @IBOutlet weak var skipforNowPotlet: UIButton!
    @IBOutlet var mobileNumber: UITextField!
    @IBOutlet var submitOutlet: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var user_master_id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.mobileNumber.delegate = self
        self.mobileNumber.tag = 1
        self.addToolBar(textField: mobileNumber)
        view.bindToKeyboard()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.preferedLanguage()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//    }
    
    
    override func viewWillLayoutSubviews() {
        submitOutlet.addShadowToButton(color: UIColor.gray, cornerRadius: 20, backgroundcolor: UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0))
    }
    
    func preferedLanguage()
    {
        appNameLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: "")
        welcomeLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "welcome_text", comment: "")
        enterMobileNumberLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "mobilenumber_text", comment: "")
        mobileNumber.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "mobilenumberplaceholder_text", comment: "")
        submitOutlet.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "login_text", comment: ""), for: .normal)
        skipforNowPotlet.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "skip_text", comment: ""), for: .normal)
    }
    
    @IBAction func submit(_ sender: Any)
    {
        self.userLogin(mobileNumber: self.mobileNumber.text!)
    }
    
    @IBAction func skipButton(_ sender: Any)
    {
        //UserDefaults.standard.getDevicetoken()
        self.skipLogin(unique_number: UIDevice.current.identifierForVendor!.uuidString, mobile_key:"akjshkajshkasj" , mobile_type: "2", user_stat: "Guest")
    }
    
    func userLogin (mobileNumber:String)
    {
        if mobileNumber.isEmpty{
            AlertController.shared.showAlert(targetVC: self, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "mobilefield", comment: ""), complition: {

            })
        }
        else if mobileNumber.count != 10
        {
            Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: "Enter the valid Mobile Number") { (action) in
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
                            self.user_master_id = json["user_master_id"].stringValue
                            UserDefaults.standard.set(self.user_master_id, forKey: "user_master_id")
                            GlobalVariables.shared.user_master_id = UserDefaults.standard.string(forKey: "user_master_id") ?? ""
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
    
    func skipLogin (unique_number: String, mobile_key: String, mobile_type: String, user_stat:String)
    {
            let parameters = ["unique_number": unique_number, "mobile_key": mobile_key, "mobile_type": mobile_type, "user_stat": user_stat]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            DispatchQueue.global().async
                {
                    do
                    {
                        try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "guest_login", params: parameters, headers: nil, success: {
                            (JSONResponse) -> Void in
                            MBProgressHUD.hide(for: self.view, animated: true)
                            print(JSONResponse)
                            let json = JSON(JSONResponse)
                            let msg = json["msg"].stringValue
                            let status = json["status"].stringValue
                            if msg == "Success" && status == "success"{
                              GlobalVariables.shared.user_master_id = ""
                              self.performSegue(withIdentifier: "guest_Home", sender: self)
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
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField.tag == 1
        {
            print("YES")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let maxLength = 10
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "to_OTP") {
            let vc = segue.destination as! OTP
            vc.user_master_id = GlobalVariables.shared.user_master_id
            vc.mobileNumber = UserDefaults.standard.string(forKey: "phone_no") ?? ""
            vc.otp = UserDefaults.standard.string(forKey: "otp_key") ?? ""
            print(vc.otp)
        }
        else if (segue.identifier == "guest_Home")
        {
            let vc = segue.destination as! Tabbarcontroller
            print(vc)
        }
    }
    
}


