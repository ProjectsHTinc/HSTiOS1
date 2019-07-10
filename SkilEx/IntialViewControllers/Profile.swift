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
    
    var isEditButtonIsClicked = true

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nametTextfiled: UITextField!
    @IBOutlet var genderTextfiled: UITextField!
    @IBOutlet var emailTextfiled: UITextField!
    @IBOutlet var addressTextfiled: UITextField!
    @IBOutlet var submit: UIButton!
    @IBOutlet var showImagePickerOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.nametTextfiled.tag = 1
        self.genderTextfiled.tag = 2
        self.emailTextfiled.tag = 3
        self.addressTextfiled.tag = 4
        self.hideKeyboardWhenTappedAround()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)

        if  userdata?.fullName == nil && userdata?.gender == nil && userdata?.email == nil && userdata?.address == nil && profileImage == nil{
            nametTextfiled.text = ""
            genderTextfiled.text = ""
            emailTextfiled.text = ""
            addressTextfiled.text = ""
            if userdata?.profilePic?.isEmpty == true
            {
                self.profileImageView.image = UIImage(named: "user.png")
            }
            self.submit.setTitle("Submit", for: .normal)
        }
        else
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            nametTextfiled.text = userdata?.fullName
            genderTextfiled.text = userdata?.gender
            emailTextfiled.text = userdata?.email
            addressTextfiled.text = userdata?.address
            if userdata?.profilePic?.isEmpty == true
            {
                self.profileImageView.image = UIImage(named: "user.png")
            }
            else
            {
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
            self.submit.setTitle("Update", for: .normal)
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        
        submit.addShadowToButton(color: UIColor.gray, cornerRadius: self.submit.frame.height / 2, backgroundcolor: UIColor(red: 0.0/255, green: 108.0/255, blue: 255.0/255, alpha: 1.0))
    }
    
    

    @IBAction func submitBtn(_ sender: Any)
    {
        if userdata?.fullName == nil && userdata?.gender == nil && userdata?.email == nil && userdata?.address == nil && profileImage == nil{
            
            self.submitProfile(name: nametTextfiled.text!, gender: genderTextfiled.text!, email: emailTextfiled.text!, address: addressTextfiled.text!)
        }
        else{
            self.updateProfile(name: nametTextfiled.text!, gender: genderTextfiled.text!, email: emailTextfiled.text!, address: addressTextfiled.text!)

        }
    }
    
    func submitProfile(name:String,gender:String,email:String,address:String){
        
        if name.isEmpty{
            
            Alert.defaultManager.showOkAlert("SkilEx", message: "name cannot be Empty") { (action) in
                //Custom action code
            }
        }
        else if gender.isEmpty{
            
            Alert.defaultManager.showOkAlert("SkilEx", message: "gender cannot be Empty") { (action) in
                //Custom action code
            }
        }
        else if email.isEmpty{
            
            Alert.defaultManager.showOkAlert("SkilEx", message: "email cannot be Empty") { (action) in
                //Custom action code
            }
        }
        else if address.isEmpty{
            
            Alert.defaultManager.showOkAlert("SkilEx", message: "address cannot be Empty") { (action) in
                //Custom action code
            }
        }
        else
        {
            let userdata = UserDefaults.standard.getUserData()
            let url = AFWrapper.BASE_URL + "mobile_check"
            let parameters = ["user_master_id": userdata?.usermasterId, "full_name": name, "gender": gender, "address": address, "email": email]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            DispatchQueue.global().async
                {
                    do
                    {
                        try AFWrapper.requestPOSTURL(url, params: (parameters as! [String : String]), headers: nil, success: {
                            (JSONResponse) -> Void in
                            MBProgressHUD.hide(for: self.view, animated: true)
                            print(JSONResponse)
                            let json = JSON(JSONResponse)
                            print(json)
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
    
    func updateProfile(name:String,gender:String,email:String,address:String){
        
        if name.isEmpty{
            
            Alert.defaultManager.showOkAlert("SkilEx", message: "name cannot be Empty") { (action) in
                //Custom action code
            }
        }
        else if gender.isEmpty{
            
            Alert.defaultManager.showOkAlert("SkilEx", message: "gender cannot be Empty") { (action) in
                //Custom action code
            }
        }
        else if email.isEmpty{
            
            Alert.defaultManager.showOkAlert("SkilEx", message: "email cannot be Empty") { (action) in
                //Custom action code
            }
        }
        else if address.isEmpty{
            
            Alert.defaultManager.showOkAlert("SkilEx", message: "address cannot be Empty") { (action) in
                //Custom action code
            }
        }
        else
        {
            let parameters = ["user_master_id": userdata?.usermasterId, "full_name": name, "gender": gender, "address": address, "email": email]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            DispatchQueue.global().async
                {
                    do
                    {
                        try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "profile_update", params: (parameters as! [String : String]), headers: nil, success: {
                            (JSONResponse) -> Void in
                            MBProgressHUD.hide(for: self.view, animated: true)
                            print(JSONResponse)
                            let json = JSON(JSONResponse)
                            print(json)
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
        let url = AFWrapper.BASE_URL + "profile_pic_upload" + "/" + userdata!.usermasterId!
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
                            let pictureUrl = json["picture_url"]
                            let defaults = UserDefaults.standard
                            defaults.set(pictureUrl, forKey: "profile_pic")
                            
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

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
       
        
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
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
