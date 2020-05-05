//
//  Profile.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 28/06/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON

class UserProfile: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userMobileNumber: UILabel!
    @IBOutlet weak var userMailId: UILabel!
    @IBOutlet weak var profileSettingsLabel: UILabel!
    @IBOutlet weak var aboutSkilexLabel: UILabel!
    @IBOutlet weak var shareSkilexLabel: UILabel!
    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var changeLangugaeLabel: UILabel!
    @IBOutlet weak var referLabel: UILabel!
    @IBOutlet weak var walletLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated:true);
        self.profileView()
        if GlobalVariables.shared.user_master_id == ""
        {
            Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "noinfpormationguest", comment: "")) { (action) in
            }
            self.userName.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "GuestUSER", comment: "")
            self.userMobileNumber.text = "-"
            self.userMailId.text = "-"
            self.preferedLanguage()
            
            
        }
        else
        {
            self.preferedLanguage()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.preferedLanguage()       
    }
    
    func preferedLanguage()
    {
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "userprofilenav_text", comment: "")
        profileSettingsLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "profilesettings_text", comment: "")
        aboutSkilexLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "aboutSkilex_text", comment: "")
        shareSkilexLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "shareSkilex_text", comment: "")
        changeLangugaeLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "languagechange_text", comment: "")
        referLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "referEarn_text", comment: "")
        walletLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "wallet_text", comment: "")
        logoutLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "logout_text", comment: "")
        self.changeTabbarTitle ()
    }
    
    func changeTabbarTitle ()
    {
        tabBarController?.tabBar.items![0].title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "hometab_text", comment: "")
        tabBarController?.tabBar.items![1].title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicetab_text", comment: "")
        tabBarController?.tabBar.items![2].title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "profiletab_text", comment: "")
    }
    
    
    func profileView ()
    {
        let parameters = ["user_master_id": GlobalVariables.shared.user_master_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "user_info", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let msg_en = json["msg_en"].stringValue
                        let msg_ta = json["msg_ta"].stringValue
                        let status = json["status"].stringValue
                        if msg == "User information" && status == "success"
                        {
                            let userdata = UserData(json: json["user_details"])
                            UserDefaults.standard.saveUserdata(userdata: userdata)
                            self.updateUserDetails()
                        }
                        else
                        {
                            if LocalizationSystem.sharedInstance.getLanguage() == "en"
                            {
                                Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_en) { (action) in
                                    //Custom action code
//                                    self.performSegue(withIdentifier: "bookingSuccess", sender: self)
                                }
                            }
                            else
                            {
                                Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_ta) { (action) in
                                    //Custom action code
//                                    self.performSegue(withIdentifier: "bookingSuccess", sender: self)
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
    
    func updateUserDetails()
    {
        let userdata = UserDefaults.standard.getUserData()

        if  userdata?.fullName == nil && userdata?.email == nil  && userdata?.profilePic == nil
        {
            self.userName.text = ""
            self.userMobileNumber.text = ""
            self.userMailId.text = ""
            if userdata?.profilePic?.isEmpty == true
            {
                self.userImage.image = UIImage(named: "user")
            }
        }
        else
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.userName.text = userdata?.fullName
            self.userMobileNumber.text = userdata?.phoneNumber
            self.userMailId.text = userdata?.email
            if userdata?.profilePic?.isEmpty == true
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.userImage.image = UIImage(named: "user")
            }
            else
            {
                let url = URL(string: (userdata?.profilePic)!)
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: url!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self!.userImage.image = image
                                self!.userImage.makeRounded()
                                MBProgressHUD.hide(for: self!.view, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func profileButton(_ sender: Any)
    {
        if GlobalVariables.shared.user_master_id == ""
        {
            let alertController = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "guestclickprofile", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            
            let okAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "login_text", comment: ""), style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.performSegue(withIdentifier: "to_Login", sender: self)
                
            }
            let cancelAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "cancel", comment: ""), style: UIAlertAction.Style.default) {
                UIAlertAction in
                
            }
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            self.performSegue(withIdentifier: "to_Profile", sender: self)
        }
    }
    
    @IBAction func aboutSkilex(_ sender: Any)
    {
        self.performSegue(withIdentifier: "aboutUs", sender: self)
    }
    
    @IBAction func shareSkilex(_ sender: Any)
    {
        let urlString = NSURL(string:"https://apps.apple.com/us/app/skilex/id1484596811?ls=1")
        
        let activityVC = UIActivityViewController(activityItems: [urlString as Any], applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.print, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToVimeo]
        present(activityVC, animated: true, completion: nil)
        
        //this is required for iPad since activityVC defaults to popover presentation
        if let popOver = activityVC.popoverPresentationController {
          popOver.sourceView = self.view
        }
    }
        
    @IBAction func changeLanguageAction(_ sender: Any)
    {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        let firstAction: UIAlertAction = UIAlertAction(title: "தமிழ்", style: .default) { action -> Void in
            
            print("First Action pressed")
            self.changeLanguage(language: "ta")
            self.languageUpdate(language_id: "1")
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "English", style: .default) { action -> Void in
            
            print("Second Action pressed")
            self.changeLanguage(language: "en")
            self.languageUpdate(language_id: "2")

        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        
        
        // present an actionSheet...
        // present(actionSheetController, animated: true, completion: nil)   // doesn't work for iPad
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            actionSheetController.popoverPresentationController?.sourceView = self.view
            actionSheetController.popoverPresentationController?.sourceRect = self.view.bounds
            actionSheetController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        } // works for both iPhone & iPad
        
        present(actionSheetController, animated: true) {
            print("option menu presented")
        }
    }
    
    func changeLanguage(language:String)
    {
        LocalizationSystem.sharedInstance.setLanguage(languageCode: language)
        self.viewDidLoad()
    }
    
    func languageUpdate (language_id:String)
    {
        let parameters = ["user_master_id": GlobalVariables.shared.user_master_id, "lang_id": language_id]
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
    
    @IBAction func logOut(_ sender: Any)
    {
        
        let alertController = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "LogOutAccess", comment: ""), preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "LogOutAccessButtonOK", comment: ""), style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            GlobalVariables.shared.user_master_id = ""
            GlobalVariables.shared.Service_amount = ""
            GlobalVariables.shared.main_catID = ""
            GlobalVariables.shared.sub_catID = ""
            GlobalVariables.shared.catServicetID = ""
            GlobalVariables.shared.viewPage = ""
            GlobalVariables.shared.serviceID = ""
            GlobalVariables.shared.walletAmount = ""
            UserDefaults.standard.set("", forKey: "user_master_id")
            UserDefaults.standard.set("", forKey: "phone_no")
            UserDefaults.standard.set("", forKey: "otp_key")
            UserDefaults.standard.set("", forKey: "Advance/customer")
            UserDefaults.standard.set("", forKey: "PaybyCash")
            UserDefaults.standard.clearUserData()
            UserDefaults.standard.set("", forKey: "user_master_id")
            self.performSegue(withIdentifier: "to_Login", sender: self)
            
        }
        let cancelAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "LogOutAccessButtonCancel", comment: ""), style: UIAlertAction.Style.default) {
            UIAlertAction in
            
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)

    }
    
    @IBAction func referandEarn(_ sender: Any)
    {
        self.performSegue(withIdentifier: "to_ReferAndEarn", sender: self)
    }
    
    @IBAction func wallet(_ sender: Any)
    {
        self.performSegue(withIdentifier: "to_AddWallet", sender: self)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "to_Profile"){
            
            let _ = segue.destination as! Profile
        }
        
        else if (segue.identifier == "aboutUs")
        {
            let _ = segue.destination as! AboutUs
        }
    }
}
