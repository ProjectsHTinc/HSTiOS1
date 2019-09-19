//
//  OTP.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 08/05/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class OTP: UIViewController,UITextFieldDelegate {

    @IBOutlet var textfiledOne: UITextField!
    @IBOutlet var textfieldTwo: UITextField!
    @IBOutlet var textfieldThree: UITextField!
    @IBOutlet var textfieldFour: UITextField!
    @IBOutlet var submitOutlet: UIButton!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var enterVerificationCodeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var resendOutlet: UIButton!
    @IBOutlet weak var notReciveOTPLabel: UILabel!
    
    var mobileNumber = String()
    var otp = String()
    var user_master_id = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.bindToKeyboard()
        self.mobileNumberLabel.text = String(format: "%@ %@", "+91", mobileNumber)
        self.textfiledOne.delegate = self
        self.textfieldTwo.delegate = self
        self.textfieldThree.delegate = self
        self.textfieldFour.delegate = self
        
//      self.textfiledOne.tag = 1
        
        self.addToolBar(textField:textfiledOne)
        self.addToolBar(textField:textfieldTwo)
        self.addToolBar(textField:textfieldThree)
        self.addToolBar(textField:textfieldFour)
      
        textfiledOne.addShadowToTextField(cornerRadius: self.textfiledOne.frame.height / 2)
        textfiledOne.addShadowToTextField(color: UIColor.gray, cornerRadius: self.textfiledOne.frame.height / 2)
        textfieldTwo.addShadowToTextField(cornerRadius: self.textfiledOne.frame.height / 2)
        textfieldTwo.addShadowToTextField(color: UIColor.gray, cornerRadius: self.textfiledOne.frame.height / 2)
        textfieldThree.addShadowToTextField(cornerRadius: self.textfiledOne.frame.height / 2)
        textfieldThree.addShadowToTextField(color: UIColor.gray, cornerRadius: self.textfiledOne.frame.height / 2)
        textfieldFour.addShadowToTextField(cornerRadius: self.textfiledOne.frame.height / 2)
        textfieldFour.addShadowToTextField(color: UIColor.gray, cornerRadius: self.textfiledOne.frame.height / 2)
       
        textfiledOne.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textfieldTwo.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textfieldThree.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textfieldFour.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        self.hideKeyboardWhenTappedAround()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.preferedLanguage()
    }
    
    override func viewWillLayoutSubviews() {
        submitOutlet.addShadowToButton(color: UIColor.gray, cornerRadius: self.submitOutlet.frame.height / 2, backgroundcolor: UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0))
        submitOutlet.clipsToBounds = true
    }
    
    func preferedLanguage()
    {
        enterVerificationCodeLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "enterverificationCode_text", comment: "")
        contentLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "content_text", comment: "")
        resendOutlet.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "resend_text", comment: ""), for: .normal)
        notReciveOTPLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "notsendOTP_text", comment: "")
    }
    
  
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case textfiledOne:
                textfieldTwo.becomeFirstResponder()
            case textfieldTwo:
                textfieldThree.becomeFirstResponder()
            case textfieldThree:
                textfieldFour.becomeFirstResponder()
            case textfieldFour:
                textfieldFour.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case textfiledOne:
                textfiledOne.becomeFirstResponder()
            case textfieldTwo:
                textfiledOne.becomeFirstResponder()
            case textfieldThree:
                textfieldTwo.becomeFirstResponder()
            case textfieldFour:
                textfieldThree.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let maxLength = 1
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }

    @IBAction func submitButton(_ sender: Any)
    {
        self.webRequest(OTP: String(format: "%@%@%@%@", self.textfiledOne.text!,self.textfieldTwo.text!,self.textfieldThree.text!,self.textfieldFour.text!), uniqueNumber: UIDevice.current.identifierForVendor!.uuidString)
    }
    
    func webRequest (OTP:String, uniqueNumber: String)
    {
        if OTP.isEmpty{

            Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: "Otp cannot be Empty") { (action) in
                //Custom action code
            }
        }
        else if OTP != otp
        {
            Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: "Otp is Wrong") { (action) in
                //Custom action code
            }
        }
        else
        {
            //UserDefaults.standard.getDevicetoken()
            let parameters = ["user_master_id":user_master_id, "phone_no": mobileNumber, "otp":OTP, "device_token":"jshdkajhd" , "mobile_type": "2", "uniqueNumber": uniqueNumber]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            DispatchQueue.global().async
                {
                    do
                    {
                        try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "login", params: (parameters ), headers: nil, success: {
                            (JSONResponse) -> Void in
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let json = JSON(JSONResponse)
                            let msg = json["msg"].stringValue
                            let msg_en = json["msg_en"].stringValue
                            let msg_ta = json["msg_ta"].stringValue
                            let status = json["status"].stringValue
                            if msg == "Login Successfully" && status == "success"{
                                let userdata = UserData(json: json["userData"])
                                UserDefaults.standard.saveUserdata(userdata: userdata)
                                self.performSegue(withIdentifier: "toDashboard", sender: self)
                            }
                            else
                            {
                                if LocalizationSystem.sharedInstance.getLanguage() == "en"
                                {
                                    Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_en) { (action) in
                                        //Custom action code
                                    }
                                }
                                else
                                {
                                    Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_ta) { (action) in
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

    }
    @IBAction func resendButton(_ sender: Any)
    {
       self.webrequestResendOtp(mobileNumber: mobileNumber)
    }
    
    func webrequestResendOtp (mobileNumber: String)
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
                            self.otp = UserDefaults.standard.string(forKey: "otp_key") ?? ""
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
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
          if (segue.identifier == "toDashboard"){
          let vc = segue.destination as! Tabbarcontroller
            print(vc)
        }
    }


}

