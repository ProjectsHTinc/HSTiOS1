//
//  Profile.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 28/06/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import MBProgressHUD

class UserProfile: UIViewController {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userMobileNumber: UILabel!
    @IBOutlet weak var userMailId: UILabel!
    
    let userdata = UserDefaults.standard.getUserData()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.updateUserDetails()
    }
    
    func updateUserDetails()
    {
        if  userdata?.fullName == nil && userdata?.email == nil  && userdata?.profilePic == nil{
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
        self.performSegue(withIdentifier: "to_Profile", sender: self)
    }
    
    @IBAction func aboutSkilex(_ sender: Any)
    {
        
    }
    
    @IBAction func shareSkilex(_ sender: Any)
    {
        
    }
    
    @IBAction func logOut(_ sender: Any)
    {
        GlobalVariables.shared.user_master_id = ""
        GlobalVariables.shared.Service_amount = ""
        GlobalVariables.shared.main_catID = ""
        GlobalVariables.shared.sub_catID = ""
        GlobalVariables.shared.catServicetID = ""
         GlobalVariables.shared.viewPage = ""
        UserDefaults.standard.set("", forKey: "user_master_id")
        UserDefaults.standard.set("", forKey: "phone_no")
        UserDefaults.standard.set("", forKey: "otp_key")
        UserDefaults.standard.clearUserData()
        self.performSegue(withIdentifier: "to_Login", sender: self)

    }
    

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "to_Profile"){
            
        }
    }


}
