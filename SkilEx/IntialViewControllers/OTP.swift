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

class OTP: UIViewController {

    @IBOutlet var textfiledOne: UITextField!
    @IBOutlet var textfieldTwo: UITextField!
    @IBOutlet var textfieldThree: UITextField!
    @IBOutlet var textfieldFour: UITextField!
    @IBOutlet var textfieldFive: UITextField!
    @IBOutlet var textfieldSix: UITextField!
    @IBOutlet var submitOutlet: UIButton!
    
    var profileImage: UIImage!
    var user_msater_id = String()
    var mobileNumber = String()
    var otp = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.textfiledOne.delegate = self
        self.textfieldTwo.delegate = self
        self.textfieldThree.delegate = self
        self.textfieldFour.delegate = self
        self.textfieldFive.delegate = self
        self.textfieldSix.delegate = self
        self.textfiledOne.tag = 1
        self.textfieldTwo.tag = 2
        self.textfieldThree.tag = 3
        self.textfieldFour.tag = 4
        self.textfieldFive.tag = 5
        self.textfieldSix.tag = 6
        self.addToolBar(textField:textfiledOne)
        self.addToolBar(textField:textfieldTwo)
        self.addToolBar(textField:textfieldThree)
        self.addToolBar(textField:textfieldFour)
        self.addToolBar(textField:textfieldFive)
        self.addToolBar(textField:textfieldSix)
        textfiledOne.addShadowToTextField(cornerRadius: self.textfiledOne.frame.height / 2)
        textfiledOne.addShadowToTextField(color: UIColor.gray, cornerRadius: self.textfiledOne.frame.height / 2)
        textfieldTwo.addShadowToTextField(cornerRadius: self.textfiledOne.frame.height / 2)
        textfieldTwo.addShadowToTextField(color: UIColor.gray, cornerRadius: self.textfiledOne.frame.height / 2)
        textfieldThree.addShadowToTextField(cornerRadius: self.textfiledOne.frame.height / 2)
        textfieldThree.addShadowToTextField(color: UIColor.gray, cornerRadius: self.textfiledOne.frame.height / 2)
        textfieldFour.addShadowToTextField(cornerRadius: self.textfiledOne.frame.height / 2)
        textfieldFour.addShadowToTextField(color: UIColor.gray, cornerRadius: self.textfiledOne.frame.height / 2)
        textfieldFive.addShadowToTextField(cornerRadius: self.textfiledOne.frame.height / 2)
        textfieldFive.addShadowToTextField(color: UIColor.gray, cornerRadius: self.textfiledOne.frame.height / 2)
        textfieldSix.addShadowToTextField(cornerRadius: self.textfiledOne.frame.height / 2)
        textfieldSix.addShadowToTextField(color: UIColor.gray, cornerRadius: self.textfiledOne.frame.height / 2)
       
        textfiledOne.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textfieldTwo.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textfieldThree.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textfieldFour.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textfieldFive.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textfieldSix.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        self.hideKeyboardWhenTappedAround()
       
    }
    
    override func viewWillLayoutSubviews() {
        
        submitOutlet.addShadowToButton(color: UIColor.gray, cornerRadius: self.submitOutlet.frame.height / 2, backgroundcolor: UIColor(red: 0.0/255, green: 108.0/255, blue: 255.0/255, alpha: 1.0))
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
                textfieldFive.becomeFirstResponder()
            case textfieldFive:
                textfieldSix.becomeFirstResponder()
            case textfieldSix:
                textfieldSix.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case textfiledOne:
                textfiledOne.becomeFirstResponder()
            case textfieldTwo:
                textfieldTwo.becomeFirstResponder()
            case textfieldThree:
                textfieldThree.becomeFirstResponder()
            case textfieldFour:
                textfieldFour.becomeFirstResponder()
            case textfieldFive:
                textfieldFive.becomeFirstResponder()
            case textfieldSix:
                textfieldSix.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 1
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }

    @IBAction func submitButton(_ sender: Any)
    {
        self.webRequest(OTP: String(format: "%@%@%@%@%@%@", self.textfiledOne.text!,self.textfieldTwo.text!,self.textfieldThree.text!,self.textfieldFour.text!,self.textfieldFive.text!,self.textfieldSix.text!))
    }
    
    func webRequest (OTP:String)
    {
//        if OTP.isEmpty{
//
//            Alert.defaultManager.showOkAlert("SkilEx", message: "Mobile Number cannot be Empty") { (action) in
//                //Custom action code
//            }
//        }
//        else if OTP != otp
//        {
//            Alert.defaultManager.showOkAlert("SkilEx", message: "Otp is Wrong") { (action) in
//                //Custom action code
//            }
//        }
//        else
//        {
//            let parameters = ["user_master_id":user_msater_id, "phone_no": mobileNumber, "otp":OTP, "device_token": UserDefaults.standard.getDevicetoken(), "mobile_type": "2"]
//            MBProgressHUD.showAdded(to: self.view, animated: true)
//            DispatchQueue.global().async
//                {
//                    do
//                    {
//                        try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "login", params: (parameters), headers: nil, success: {
//                            (JSONResponse) -> Void in
//                            let json = JSON(JSONResponse)
//                            let msg = json["msg"].stringValue
//                            let status = json["status"].stringValue
//                            if msg == "Login Successfully" && status == "success"{
//                                let userdata = UserData(json: json["userData"])
//                                UserDefaults.standard.saveUserdata(userdata: userdata)
//                                let imgUrl = json["userData"]["profile_pic"].string
//                                if imgUrl?.isEmpty == true
//                                {
//                                    self.profileImage = UIImage(named: "user.png")
//                                }
//                                else
//                                {
//                                    let url = URL(string: imgUrl!)
//                                    DispatchQueue.global().async { [weak self] in
//                                        if let data = try? Data(contentsOf: url!) {
//                                            if let image = UIImage(data: data) {
//                                                DispatchQueue.main.async {
//                                                    self?.profileImage = image
//                                                    MBProgressHUD.hide(for: self!.view, animated: true)
//                                                    self!.performSegue(withIdentifier: "toDashboard", sender: self)
//                                                }
//                                            }
//                                        }
//                                    }
//                                    print(userdata)
//                                }
//                            }
//                            else
//                            {
//                                Alert.defaultManager.showOkAlert("SkilEx", message: msg) { (action) in
//                                    // Custom action code
//                                }
//                            }
//                        }) {
//                            (error) -> Void in
//                            print(error)
//                        }
//                    }
//                    catch
//                    {
//                        print("Unable to load data: \(error)")
//                    }
//            }
//        }
        
        self.performSegue(withIdentifier: "toDashboard", sender: self)

    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "to_Profile") {
            let vc = segue.destination as! Profile
            vc.profileImage = profileImage
        }
        else if (segue.identifier == "toDashboard"){
          let vc = segue.destination as! Tabbarcontroller
            print(vc)
        }
    }


}

