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
    
    var profileImage: UIImage!
    var user_msater_id = String()
    var mobileNumber = String()
    var otp = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.textfiledOne.delegate = self
        self.textfiledOne.tag = 1
        self.addToolBar(textField: textfiledOne)
        self.hideKeyboardWhenTappedAround()
       
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField.tag == 2
        {
            print("YES")
        }
    }

    @IBAction func submitButton(_ sender: Any)
    {
        self.webRequest(OTP: textfiledOne.text!)
    }
    
    func webRequest (OTP:String)
    {
        if OTP.isEmpty{
            
            Alert.defaultManager.showOkAlert("SkilEx", message: "Mobile Number cannot be Empty") { (action) in
                //Custom action code
            }
        }
        else if OTP != otp
        {
            Alert.defaultManager.showOkAlert("SkilEx", message: "Otp is Wrong") { (action) in
                //Custom action code
            }
        }
        else
        {
            let parameters = ["user_master_id":user_msater_id, "phone_no": mobileNumber, "otp":OTP, "device_token": UserDefaults.standard.getDevicetoken(), "mobile_type": "2"]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            DispatchQueue.global().async
                {
                    do
                    {
                        try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "login", params: (parameters), headers: nil, success: {
                            (JSONResponse) -> Void in
                            let json = JSON(JSONResponse)
                            let msg = json["msg"].stringValue
                            let status = json["status"].stringValue
                            if msg == "Login Successfully" && status == "success"{
                                let userdata = UserData(json: json["userData"])
                                UserDefaults.standard.saveUserdata(userdata: userdata)
                                let imgUrl = json["userData"]["profile_pic"].string
                                let url = URL(string: imgUrl!)
                                DispatchQueue.global().async { [weak self] in
                                    if let data = try? Data(contentsOf: url!) {
                                        if let image = UIImage(data: data) {
                                            DispatchQueue.main.async {
                                                self?.profileImage = image
                                                MBProgressHUD.hide(for: self!.view, animated: true)
                                                self!.performSegue(withIdentifier: "to_Profile", sender: self)
                                            }
                                        }
                                    }
                                }
                                print(userdata)
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
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "to_Profile") {
            let vc = segue.destination as! Profile
            vc.profileImage = profileImage
        }
    }


}
