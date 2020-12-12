//
//  Profile.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 11/05/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
import SDWebImage

class Profile: UIViewController
{
    var imagePicker: ImagePicker!
    var profileImage: UIImage!
    let userdata = UserDefaults.standard.getUserData()
    
    var isMaleButtonClicked = true
    var isFemaleButtonClicked = true
    var gender = String()

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nametTextfiled: UITextField!
    @IBOutlet var genderTextfiled: UITextField!
    @IBOutlet var emailTextfiled: UITextField!
    @IBOutlet var submit: UIButton!
    @IBOutlet var showImagePickerOutlet: UIButton!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var registerMobileNumberLabel: UILabel!
    @IBOutlet weak var mailIdLabel: UILabel!
    @IBOutlet weak var maleImgView: UIImageView!
    @IBOutlet weak var femaleImgView: UIImageView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var mobileNumberTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.bindToKeyboard()

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.preferedLanguage()
        self.addBackButton()
        self.nametTextfiled.tag = 1
        //self.mobileNumberTextfield.tag = 2
        self.emailTextfiled.tag = 3
        self.hideKeyboardWhenTappedAround()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        print(userdata?.fullName as Any,userdata?.gender as Any,userdata?.profilePic as Any)
        if  userdata?.fullName == nil && userdata?.gender == nil && userdata?.email == nil && userdata?.phoneNumber == nil && userdata?.profilePic == nil{
            nametTextfiled.text = ""
           // mobileNumberTextfield.text = ""
            emailTextfiled.text = ""
            if userdata?.profilePic?.isEmpty == true
            {
                self.profileImageView.image = UIImage(named: "user")
            }
            self.submit.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "submit_profile_text", comment: ""), for: .normal)
        }
        else
        {
            nametTextfiled.text = userdata?.fullName
           // mobileNumberTextfield.text = userdata?.address
            emailTextfiled.text = userdata?.email
            let gender = userdata?.gender
            if gender == "Male"
            {
                isMaleButtonClicked = false
                isFemaleButtonClicked = true
                self.maleImgView.image = UIImage (named: "radio_buttonselect")
                self.femaleImgView.image = UIImage (named: "radio_Deselect")
                self.maleLabel.textColor = UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0)
                self.femaleLabel.textColor = UIColor.gray
                self.gender = "Male"
            }
            else if gender == "Female"
            {
                isFemaleButtonClicked = false
                isMaleButtonClicked = true
                self.femaleImgView.image = UIImage (named: "radio_buttonselect")
                self.maleImgView.image = UIImage (named: "radio_Deselect")
                self.femaleLabel.textColor = UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0)
                self.maleLabel.textColor = UIColor.gray
                self.gender = "Female"
            }
            
            if userdata?.profilePic?.isEmpty == true
            {
                self.profileImageView.image = UIImage(named: "user")
            }
            else
            {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                let url = URL(string: (userdata?.profilePic)!)
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: url!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self!.profileImageView.image = image
                                self!.profileImageView.makeRounded()
                                MBProgressHUD.hide(for: self!.view, animated: true)
                            }
                        }
                    }
                }
            }
            self.submit.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "submit_profile_text", comment: ""), for: .normal)
        }
    }
    
    func preferedLanguage()
    {
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "profilenavtitle_text", comment: "")
        fullNameLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "fullname_text", comment: "")
    //  registerMobileNumberLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "address_text", comment: "")
        mailIdLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "mailid_text", comment: "")
        genderLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "gender_text", comment: "")
        maleLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "male_text", comment: "")
        femaleLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "female_text", comment: "")
        submit.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "submit_profile_text", comment: ""), for: .normal)
    }
    
    @objc public override func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillLayoutSubviews()
    {
        submit.addShadowToButton(color: UIColor.gray, cornerRadius:self.submit.layer.frame.height/2 , backgroundcolor: UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0))
    }
    
    @IBAction func submitBtn(_ sender: Any)
    {
        self.updateProfile(name: nametTextfiled.text!, gender: self.gender, email: emailTextfiled.text!)
    }
    
    func updateProfile(name:String,gender:String,email:String){
        
        if name.isEmpty{
            AlertController.shared.showAlert(targetVC: self, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "namefield", comment: ""), complition: {

            })
        }
        else if self.gender == ""
        {
            AlertController.shared.showAlert(targetVC: self, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "namefield", comment: ""), complition: {

            })
        }
        else
        {
            let parameters = ["user_master_id": GlobalVariables.shared.user_master_id, "full_name": name, "gender": gender, "email": email]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            DispatchQueue.global().async
                {
                    do
                    {
                        try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "profile_update", params: (parameters), headers: nil, success: {
                            (JSONResponse) -> Void in
                            MBProgressHUD.hide(for: self.view, animated: true)
                            print(JSONResponse)
                            let json = JSON(JSONResponse)
                            let msg = json["msg"].stringValue
//                          let msg_en = json["msg_en"].stringValue
//                          let msg_ta = json["msg_ta"].stringValue
                            let status = json["status"].stringValue
                            if msg == "Profile Updated" && status == "success"
                            {
                                if LocalizationSystem.sharedInstance.getLanguage() == "en"
                                {
                                    AlertController.shared.showAlert(targetVC: self, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: "Profile updated", complition: {
                                        self.performSegue(withIdentifier: "userprofile", sender: self)
                                    })
                                }
                                else
                                {
                                    AlertController.shared.showAlert(targetVC: self, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: "சேமிக்கப்பட்டது", complition: {
                                        self.performSegue(withIdentifier: "userprofile", sender: self)
                                    })
                                }
                            }
                            else
                            {
                                if LocalizationSystem.sharedInstance.getLanguage() == "ta"
                                {
                                     AlertController.shared.showAlert(targetVC: self, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: "சேமிக்கப்பட்டது", complition: {
//                                         self.performSegue(withIdentifier: "userprofile", sender: self)
                                     })
                                }
                                else
                                {
                                     AlertController.shared.showAlert(targetVC: self, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: "Profile updated", complition: {
//                                          self.performSegue(withIdentifier: "userprofile", sender: self)
                                    })
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
    
    @IBAction func showImagePicker(_ sender: Any)
    {
        self.imagePicker.present(from: sender as! UIView)
    }
    
    func profilePictureUpdate (image: UIImage?) {
        
        let data:Data = (image?.jpegData(compressionQuality: 0.75))!
        let url = AFWrapper.BASE_URL + "profile_pic_upload" + "/" + GlobalVariables.shared.user_master_id
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.uploadMultipartFormData(url, params: nil, imageDataArray: [data], imageNamesArray: ["profile_pic"], headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"]
                        let status = json["status"]
                        if msg == "Profile Picture Updated" && status == "success"{
                            print(msg)
//                            let pictureUrl = json["picture_url"]
//                            let defaults = UserDefaults.standard
//                            defaults.set(pictureUrl, forKey: "profile_pic")
//                            let userdata = UserData(json: json["picture_url"])
//                            let userdata = UserDefaults.standard.getUserData()
//                            userdata?.profilePic = json["picture_url"].stringValue
//                            UserDefaults.standard.saveUserdata(userdata: userdata!)
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

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        // Try to find next responder
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder?
        
        if nextResponder != nil {
            // Found next responder, so set it
            nextResponder?.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    @IBAction func maleradioButton(_ sender: Any)
    {
        if isMaleButtonClicked == true
        {
            isMaleButtonClicked = false
            isFemaleButtonClicked = true
            self.maleImgView.image = UIImage (named: "radio_buttonselect")
            self.femaleImgView.image = UIImage (named: "radio_Deselect")
            self.maleLabel.textColor = UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0)
            self.femaleLabel.textColor = UIColor.gray
            self.gender = "Male"
        }
        else
        {
            isMaleButtonClicked = true
            isFemaleButtonClicked = true
            self.maleImgView.image = UIImage (named: "radio_Deselect")
            self.maleLabel.textColor = UIColor.gray
            self.gender = ""

        }
    }
    
    @IBAction func femaleradioButton(_ sender: Any)
    {
        if isFemaleButtonClicked == true
        {
            isFemaleButtonClicked = false
            isMaleButtonClicked = true
            self.femaleImgView.image = UIImage (named: "radio_buttonselect")
            self.maleImgView.image = UIImage (named: "radio_Deselect")
            self.femaleLabel.textColor = UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0)
            self.maleLabel.textColor = UIColor.gray
            self.gender = "Female"

        }
        else
        {
            isFemaleButtonClicked = true
            isMaleButtonClicked = true
            self.femaleImgView.image = UIImage (named: "radio_Deselect")
            self.femaleLabel.textColor = UIColor.gray
            self.gender = ""

        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "userprofile")
        {
            let _ = segue.destination as! UserProfile
        }
    }
  
    
}

extension Profile: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        
        if image == nil
        {
           self.profileImageView.image = profileImage
        }
        else
        {
            self.profileImageView.image = image
            self.profilePictureUpdate(image: image)
            self.profileImageView.makeRounded()
        }
    }
}

//extension UIImage {
//
//    var pngRepresentationData: Data? {
//        return self.pngData()
//    }
//
//    var jpegRepresentationData: Data? {
//        return jpegData(compressionQuality: 0.75)
//    }
//}
