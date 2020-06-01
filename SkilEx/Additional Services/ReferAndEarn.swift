//
//  ReferAndEarn.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 27/04/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class ReferAndEarn: UIViewController {

    @IBOutlet weak var totalRewardsLabel: UILabel!
    @IBOutlet weak var pointsBgView: UIView!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var rewardBtnOutlet: UIButton!
    @IBOutlet weak var earnAmountLabel: UILabel!
    @IBOutlet weak var inviteLabel: UILabel!
    @IBOutlet weak var referralCodeLabel: UILabel!
    @IBOutlet weak var referalCodeTextField: UITextField!
    @IBOutlet weak var referFriendOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.userPointsAndCode()
        //self.referalCodeTextField.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
      self.preferedLanguage()
      self.addBackButton()
      self.pointsBgView.backgroundColor = UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0)
      rewardBtnOutlet.addShadowToButton(color: UIColor.gray, cornerRadius: self.rewardBtnOutlet.frame.height / 2, backgroundcolor: UIColor.white)
      referFriendOutlet.addShadowToButton(color: UIColor.gray, cornerRadius: self.referFriendOutlet.frame.height / 2, backgroundcolor: UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0))
      let myColor = UIColor.gray
      referalCodeTextField.layer.borderWidth = 1.0
      referalCodeTextField.layer.borderColor = myColor.cgColor
      referalCodeTextField.clipsToBounds = true
    }
    
    func preferedLanguage()
    {
        self.navigationItem.title =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "referAndEarnnavtitle_text", comment: "")
    }
    
    @objc public override func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func userPointsAndCode ()
    {
        let parameters = ["user_master_id": GlobalVariables.shared.user_master_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "user_points_referral_code", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
//                      let msg = json["msg"].stringValue
                        let status = json["status"].stringValue
                        if status == "success"{
                           let pointsTo_claim = json["points_code"]["points_to_claim"].string
                           let referralCode = json["points_code"]["referral_code"].string
                           self.updatePoints(points_to_claim: pointsTo_claim!, referral_code: referralCode!)
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
    
    func updatePoints  (points_to_claim:String,referral_code:String)
    {
        if points_to_claim.isEmpty
        {
            self.points.text = "0" + "" + "Points"
        }
        else
        {
            self.points?.text = points_to_claim + " " + "Points"
        }
        
        if referral_code.isEmpty
        {
            self.referalCodeTextField.text = ""

        }
        else
        {
            self.referalCodeTextField?.text = referral_code
        }
    }
    
    @IBAction func rewardAction(_ sender: Any)
    {
        self.checkforClaim()
    }
    
    func checkforClaim ()
    {
        let parameters = ["user_master_id": GlobalVariables.shared.user_master_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "check_to_claim_points", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
//                      let msg_en = json["msg_en"].stringValue
//                      let msg_ta = json["msg_ta"].stringValue
                        let status = json["status"].stringValue
                        if  msg == "Can Claim" && status == "success"{
                           let amount_to_be_claim = json["amount_to_be_claim"].stringValue
                           self.showAlertView(totalPoints: amount_to_be_claim)
                        }
                        else
                        {
                            if LocalizationSystem.sharedInstance.getLanguage() == "en"
                            {
                                Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg) { (action) in
                                    //Custom action code
                                }
                            }
                            else
                            {
                                Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg) { (action) in
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
    
    func showAlertView (totalPoints:String)
    {
        DispatchQueue.main.async{
            let alertController = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: "Your amount for point earned is \(totalPoints) ", preferredStyle: UIAlertController.Style.alert)
            
            
            let okAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Proceed to add money", comment: ""), style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.ConfrimtoClaim(usermasterId:GlobalVariables.shared.user_master_id)
            }
            let cancelAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Cancel", comment: ""), style: UIAlertAction.Style.default) {
                UIAlertAction in
                
            }
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func ConfrimtoClaim (usermasterId:String)
    {
        let parameters = ["user_master_id": usermasterId]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "confirm_to_claim", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let msg_en = json["msg_en"].stringValue
                        let msg_ta = json["msg_ta"].stringValue
                        let status = json["status"].stringValue
                        if  msg == "Amount added in wallet!" && status == "success"{
                            self.userPointsAndCode()
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
    
        
    @IBAction func referFriendAction(_ sender: Any)
    {
        if !self.referalCodeTextField.text!.isEmpty
        {
            let text = "Download SkilEx – The ultimate service app for all you home and office service needs. Enter my code \(self.referalCodeTextField.text!) to earn 50 points worth ₹25 in your SkilEx wallet redeemed during service payment. Download our app now \("https://apps.apple.com/us/app/skilex/id1484596811?ls=1")"
            
            let activityVC = UIActivityViewController(activityItems: [text as Any], applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.print, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToVimeo]
            present(activityVC, animated: true, completion: nil)
            
            //this is required for iPad since activityVC defaults to popover presentation
            if let popOver = activityVC.popoverPresentationController {
              popOver.sourceView = self.view
            }
        }
        else
        {
            self.referalCodeTextField.isEnabled = false
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "to_AmountStatus")
        {
            let vc = segue.destination as! AmountStatus
            vc.amount = sender as! String
        }
    }
    

}
