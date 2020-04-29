//
//  RateServiceViewController.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 29/11/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class RateServiceViewController: UIViewController {

    @IBOutlet weak var buttonOneOutlet: UIButton!
    @IBOutlet weak var buttonTwoOutlet: UIButton!
    @IBOutlet weak var buttonThreeOutlet: UIButton!
    @IBOutlet weak var buttonFourOutlet: UIButton!
    @IBOutlet weak var buttonFiveOutlet: UIButton!
    @IBOutlet weak var submitOutlet: UIButton!
    @IBOutlet weak var skipOutlet: UIButton!
    
    var first = "0"
    var second = "0"
    var third = "0"
    var four = "0"
    var five = "0"
    var selectedStars = "0"
    
    
    var selectedValue = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.preferedLanguage()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.preferedLanguage()

    }
    
    func preferedLanguage()
    {
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "rateServicenavtitle_text", comment: "")
        submitOutlet.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "rateServicSubmitBtn_text", comment: ""), for: .normal)
        skipOutlet.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "rateServicSkipBtn_text", comment: ""), for: .normal)
    }
    
    override func viewWillLayoutSubviews() {
        
            let width = self.view.frame.width
            let navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: width, height: 44))
            self.view.addSubview(navigationBar);
            let navigationItem = UINavigationItem(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "rateServicenavtitle_text", comment: ""))
            navigationBar.setItems([navigationItem], animated: false)
            navigationBar.barTintColor = UIColor(red: 19/255.0, green: 90/255.0, blue: 160/255.0, alpha: 1.0)
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            submitOutlet.addShadowToButton(color: UIColor.gray, cornerRadius: 16, backgroundcolor: UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0))
       }
    
    @IBAction func buttonOne(_ sender: Any)
    {
      if (first == "0")
      {
          buttonOneOutlet.setBackgroundImage(UIImage(named: "ios_icons-31"), for: UIControl.State.normal)
          first = "1";
          selectedStars = "1";
      }
      else
      {
          buttonOneOutlet.setBackgroundImage(UIImage(named: "ios_icons-32"), for: UIControl.State.normal)
          first = "0";
          buttonTwoOutlet.setBackgroundImage(UIImage(named: "ios_icons-32"), for: UIControl.State.normal)
          second = "0";
          buttonThreeOutlet.setBackgroundImage(UIImage(named: "ios_icons-32"), for: UIControl.State.normal)
          third = "0";
          buttonFourOutlet.setBackgroundImage(UIImage(named: "ios_icons-32"), for: UIControl.State.normal)
          four = "0";
          buttonFiveOutlet.setBackgroundImage(UIImage(named: "ios_icons-32"), for: UIControl.State.normal)
          five = "0";
          selectedStars = "0";
      }
    }
    
    @IBAction func buttonTwo(_ sender: Any)
    {
       if (second == "0")
       {
           buttonOneOutlet.setBackgroundImage(UIImage(named: "ios_icons-31"), for: UIControl.State.normal)
           first = "1";
           buttonTwoOutlet.setBackgroundImage(UIImage(named: "ios_icons-31"), for: UIControl.State.normal)
           second = "1";
           selectedStars = "2";
       }
       else
       {
           buttonTwoOutlet.setBackgroundImage(UIImage(named: "ios_icons-32"), for: UIControl.State.normal)
           second = "0";
           buttonThreeOutlet.setBackgroundImage(UIImage(named: "ios_icons-32"), for: UIControl.State.normal)
           third = "0";
           buttonFourOutlet.setBackgroundImage(UIImage(named: "ios_icons-32"), for: UIControl.State.normal)
           four = "0";
           buttonFiveOutlet.setBackgroundImage(UIImage(named: "ios_icons-32"), for: UIControl.State.normal)
           five = "0";
           selectedStars = "1";
       }
    }
    
    @IBAction func buttonThree(_ sender: Any)
    {
       if (third == "0")
          {
              buttonOneOutlet.setBackgroundImage(UIImage(named: "ios_icons-31"), for: UIControl.State.normal)
              first = "1";
              buttonTwoOutlet.setBackgroundImage(UIImage(named: "ios_icons-31"), for: UIControl.State.normal)
              second = "1";
              buttonThreeOutlet.setBackgroundImage(UIImage(named: "ios_icons-31"), for: UIControl.State.normal)
              third = "1";
              selectedStars = "3";
          }
          else
          {
              buttonThreeOutlet.setBackgroundImage(UIImage(named: "ios_icons-32"), for: UIControl.State.normal)
              third = "0";
              buttonFourOutlet.setBackgroundImage(UIImage(named: "ios_icons-32"), for: UIControl.State.normal)
              four = "0";
              buttonFiveOutlet.setBackgroundImage(UIImage(named: "ios_icons-32"), for: UIControl.State.normal)
              five = "0";
              selectedStars = "2";
          }
    }
    
    @IBAction func buttonFour(_ sender: Any)
    {
       if (four == "0")
          {
              buttonOneOutlet.setBackgroundImage(UIImage(named: "ios_icons-31"), for: UIControl.State.normal)
              first = "1";
              buttonTwoOutlet.setBackgroundImage(UIImage(named: "ios_icons-31"), for: UIControl.State.normal)
              second = "1";
              buttonThreeOutlet.setBackgroundImage(UIImage(named: "ios_icons-31"), for: UIControl.State.normal)
              third = "1";
              buttonFourOutlet.setBackgroundImage(UIImage(named: "ios_icons-31"), for: UIControl.State.normal)
              four = "1";
              selectedStars = "4";
          }
          else
          {
              buttonFourOutlet.setBackgroundImage(UIImage(named: "ios_icons-32"), for: UIControl.State.normal)
              four = "0";
              buttonFiveOutlet.setBackgroundImage(UIImage(named: "ios_icons-32"), for: UIControl.State.normal)
              five = "0";
              selectedStars = "3";
          }
    }
    
    @IBAction func buttonFive(_ sender: Any)
    {
      if (five == "0")
         {
             buttonOneOutlet.setBackgroundImage(UIImage(named: "ios_icons-31"), for: UIControl.State.normal)
             first = "1";
             buttonTwoOutlet.setBackgroundImage(UIImage(named: "ios_icons-31"), for: UIControl.State.normal)
             second = "1";
             buttonThreeOutlet.setBackgroundImage(UIImage(named: "ios_icons-31"), for: UIControl.State.normal)
             third = "1";
             buttonFourOutlet.setBackgroundImage(UIImage(named: "ios_icons-31"), for: UIControl.State.normal)
             four = "1";
             buttonFiveOutlet.setBackgroundImage(UIImage(named: "ios_icons-31"), for: UIControl.State.normal)
             five = "1";
             selectedStars = "5";
         }
         else
         {
              buttonFiveOutlet.setBackgroundImage(UIImage(named: "ios_icons-32"), for: UIControl.State.normal)
             five = "0";
             selectedStars = "4";
         }
    }
    
    @IBAction func submitAction(_ sender: Any)
    {
        
        if (selectedValue == "0")
        {
            
            Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "rateServicAlertBox_text", comment: "")) { (action) in
                 //Custom action code
            }
        }
        else
        {
            self.rateTheService(usermasterId:GlobalVariables.shared.user_master_id,service_order_id: GlobalVariables.shared.serviceOrderId,rating:selectedStars,review:"",status:"Pending")
        }
        
    }
    
    func rateTheService(usermasterId:String,service_order_id:String,rating:String,review:String,status:String)
    {
        let parameters = ["user_master_id": usermasterId,"service_order_id":service_order_id, "ratings":rating, "reviews":review,"status":status]
        MBProgressHUD.showAdded(to: self.view, animated: true)
       DispatchQueue.global().async
           {
               do
               {
                   try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "service_reviews_add", params: parameters, headers: nil, success: {
                       (JSONResponse) -> Void in
                       MBProgressHUD.hide(for: self.view, animated: true)
                       print(JSONResponse)
                       let json = JSON(JSONResponse)
//                       let msg = json["msg"].stringValue
//                       let msg_en = json["msg_en"].stringValue
//                       let msg_ta = json["msg_ta"].stringValue
                       let status = json["status"].stringValue
                       if status == "success"
                       {
                        self.performSegue(withIdentifier: "home", sender: self )
//                           if LocalizationSystem.sharedInstance.getLanguage() == "en"
//                           {
//                               Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_en) { (action) in
//                                   //Custom action code
//
//                               }
//                           }
//                           else
//                           {
//                               Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_ta) { (action) in
//                                   //Custom action code
//
//                               }
//                           }
                       }
                       else
                       {
//                           if LocalizationSystem.sharedInstance.getLanguage() == "en"
//                           {
//                               Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_en) { (action) in
//                                   //Custom action code
//                               }
//                           }
//                           else
//                           {
//                               Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_ta) { (action) in
//                                   //Custom action code
//                               }
//                           }
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
    
    @IBAction func skipButton(_ sender: Any)
    {
        self.performSegue(withIdentifier: "home", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "home") {
                   let _ = segue.destination as! Tabbarcontroller
               }
    }
    

}
