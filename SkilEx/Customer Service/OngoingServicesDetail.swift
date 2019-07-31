//
//  ServicesDetail.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 24/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class OngoingServicesDetail: UIViewController {
        
    @IBOutlet weak var mainCategoeryName: UILabel!
    @IBOutlet weak var subCategoeryName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var servicePersonImage: UIImageView!
    @IBOutlet weak var customerNumber: UILabel!
    @IBOutlet weak var estimatedCost: UILabel!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var contactPersonName: UILabel!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var serviceProviderName: UILabel!
    @IBOutlet weak var serviceStartTime: UILabel!
    @IBOutlet weak var callServiceProviderOutlet: UIButton!
    @IBOutlet weak var trackOutlet: UIButton!
    @IBOutlet weak var serviceProviderLabel: UILabel!
    @IBOutlet weak var serviceTimeSlotLabel: UILabel!
    @IBOutlet weak var estimatedCostLabel: UILabel!
    @IBOutlet weak var callServicePersonLabel: UILabel!
    
    var serviceorderId = String()
    let serviceListDetail = UserDefaults.standard.getServicesDetail()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addBackButton()
        self.preferedLanguage()
        self.LoadValues()
        self.subView.dropShadow(offsetX: 0, offsetY: 1, color: UIColor.gray, opacity: 0.5, radius: 6)
        
    }
    
    override func viewWillLayoutSubviews() {
       
        
        if serviceListDetail?.order_status == "Ongoing"
        {
            self.trackOutlet.isEnabled = false
            trackOutlet.addShadowToButton(color: UIColor.gray, cornerRadius: 20, backgroundcolor: UIColor.gray)
        }
        else if serviceListDetail?.order_status == "Initiated"
        {
            self.trackOutlet.isEnabled = true
            self.trackOutlet.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesdetailongoingtrack_text", comment: ""), for: .normal)
            trackOutlet.addShadowToButton(color: UIColor.gray, cornerRadius: 20, backgroundcolor: UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0))
        }
//        else if serviceListDetail?.order_status == "Completed"
//        {
//            self.orderStatus = "Completed"
//            self.trackOutlet.isEnabled = true
//            if LocalizationSystem.sharedInstance.getLanguage() == "en"
//            {
//                self.trackOutlet.setTitle("Pay Now", for: .normal)
//            }
//            else
//            {
//                self.trackOutlet.setTitle("இப்போது செலுத்த", for: .normal)
//            }
//            trackOutlet.addShadowToButton(color: UIColor.gray, cornerRadius: 20, backgroundcolor: UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0))
//        }
    }
    
    func preferedLanguage()
    {
        self.navigationItem.title =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesdetailongoingnavtitle_text", comment: "")
        self.serviceProviderLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesdetailongoingprovider_text", comment: "")
        self.serviceTimeSlotLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesdetailongoingtimeslot_text", comment: "")
        self.estimatedCostLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesdetailongoingestimatedcost_text", comment: "")
        self.callServicePersonLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesdetailongoingcallserviceperson_text", comment: "")
    }
    
    func LoadValues()
    {
        if LocalizationSystem.sharedInstance.getLanguage() == "en"
        {
            self.mainCategoeryName.text = serviceListDetail?.main_category
            self.subCategoeryName.text = serviceListDetail?.sub_category
            self.contactPersonName.text = serviceListDetail?.contact_person_name
            self.date.text = serviceListDetail?.order_date
            let imgurl = serviceListDetail?.pic
            if imgurl?.isEmpty == true
            {
                self.servicePersonImage.image = UIImage(named: "user")
            }
            else
            {
                let url = URL(string: imgurl!)
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.servicePersonImage.image = image
                            }
                        }
                    }
                }
            }
            self.personName.text = serviceListDetail?.person_name
            self.serviceStartTime.text = serviceListDetail?.time_slot
            self.estimatedCost.text = serviceListDetail?.estimated_cost
            self.serviceProviderName.text = serviceListDetail?.provider_name
            self.callServiceProviderOutlet.setTitle(serviceListDetail?.person_number, for: .normal)
        }
        else
        {
            self.mainCategoeryName.text = serviceListDetail?.main_category_ta
            self.subCategoeryName.text = serviceListDetail?.sub_category_ta
            self.contactPersonName.text = serviceListDetail?.contact_person_name
            self.date.text = serviceListDetail?.order_date
            let imgurl = serviceListDetail?.pic
            if imgurl?.isEmpty == true
            {
                self.servicePersonImage.image = UIImage(named: "user")
            }
            else
            {
                let url = URL(string: imgurl!)
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.servicePersonImage.image = image
                            }
                        }
                    }
                }
            }
            self.personName.text = serviceListDetail?.person_name
            self.serviceStartTime.text = serviceListDetail?.time_slot
            self.estimatedCost.text = serviceListDetail?.estimated_cost
            self.serviceProviderName.text = serviceListDetail?.provider_name
            self.callServiceProviderOutlet.setTitle(serviceListDetail?.person_number, for: .normal)
        }
    }
    
    @objc public override func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func callserviceProvider(_ sender: Any)
    {
        self.callNumber(phoneNumber: (serviceListDetail?.person_number!)!)
    }
    
    func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
    
    @IBAction func trackButton(_ sender: Any)
    {
        if serviceListDetail?.order_status == "Initiated"
        {
            self.performSegue(withIdentifier: "tracking", sender: self)
        }
//        else if serviceListDetail?.order_status == "Completed"
//        {
//            self.webRequestserviceOrderSummary(service_order_id:serviceorderId)
//        }
        else
        {
            self.trackOutlet.isEnabled = false
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "tracking"){
            let _ = segue.destination as! Tracking
        }
    }
    

}
