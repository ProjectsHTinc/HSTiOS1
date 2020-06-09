//
//  RequestedService.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 24/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class RequestedService: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var serviceListArr = [ServiceList]()
    var service_Order_id =  String()
    var advancePaymentStatus = String()
    var from = String()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addBackButton()
        self.webRequestRequestedServiceList(user_master_id: GlobalVariables.shared.user_master_id)
        self.preferedLanguage()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.preferedLanguage()
    }
    
    func preferedLanguage () {
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "requestedservicenavtitle_text", comment: "")
    }
    
    @objc public override func backButtonClick() {
        
        if self.from == "Service"
        {
            self.performSegue(withIdentifier: "servicePage", sender: self)
        }
        else
        {
            self.performSegue(withIdentifier: "homePage", sender: self)
        }
    }
    
    func webRequestRequestedServiceList(user_master_id: String) {
        let parameters = ["user_master_id": user_master_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "requested_services", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let msg_en = json["msg_en"].stringValue
                        let msg_ta = json["msg_ta"].stringValue
                        let status = json["status"].stringValue
                        if msg == "Service found" && status == "success"{
                            
                            if json["service_list"].count > 0 {
                                
                                self.serviceListArr = []
                                
                                for i in 0..<json["service_list"].count {
                                    
                                    let services = ServiceList.init(json: json["service_list"][i])
                                    self.serviceListArr.append(services)
                                }
                                self.tableView.reloadData()
                            }
                        }
                        else
                        {
                            if LocalizationSystem.sharedInstance.getLanguage() == "en"
                            {
                                Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_en) { (action) in
                                    //Custom action code
                                    //self.performSegue(withIdentifier: "servicePage", sender: self)
                                }
                            }
                            else
                            {
                                Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_ta) { (action) in
                                    //Custom action code
                                    //self.performSegue(withIdentifier: "servicePage", sender: self)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RequestedServiceTableViewCell
        
        let serviceList = serviceListArr[indexPath.row]
        
        if LocalizationSystem.sharedInstance.getLanguage() == "en"
        {
            cell.mainCatgoery.text = serviceList.main_category
            cell.serviceName.text = serviceList.service_name
            cell.dateLabel.text = serviceList.order_date
            cell.timeLabel.text = serviceList.time_slot
            self.advancePaymentStatus = serviceList.advance_payment_status!

        }
        else
        {
            cell.mainCatgoery.text = serviceList.main_category_ta
            cell.serviceName.text = serviceList.service_ta_name
            cell.dateLabel.text = serviceList.order_date
            cell.timeLabel.text = serviceList.time_slot
            self.advancePaymentStatus = serviceList.advance_payment_status!

        }
        
        cell.cellView.dropShadow()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = serviceListArr[indexPath.row]
        self.service_Order_id = index.service_order_id!
        self.webRequestRequestedServiceOrderDetails(service_order_id: index.service_order_id!)
    }
    
    func webRequestRequestedServiceOrderDetails(service_order_id: String) {
        let parameters = ["service_order_id": service_order_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "service_order_details", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let msg_en = json["msg_en"].stringValue
                        let msg_ta = json["msg_ta"].stringValue
                        let status = json["status"].stringValue
                        if msg == "Service found" && status == "success"
                        {
                            if json["service_list"].count > 0 {
                            let servicesDetail = ServicesListDetail(json: json["service_list"])
                            UserDefaults.standard.saveServicesDetail(servicesListDetail: servicesDetail)
                            self.performSegue(withIdentifier: "requestedServiceDetail", sender: self)
                            }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 158
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "requestedServiceDetail"){
            let vc = segue.destination as! RequestedServiceDetail
            vc.service_order_id = self.service_Order_id
            vc.advancePayment_Status = self.advancePaymentStatus

        }
        else if (segue.identifier == "servicePage")
        {
            let _ = segue.destination as! Service
        }
        else if (segue.identifier == "homePage")
        {
            let _ = segue.destination as! Tabbarcontroller
        }
    }
    
}
