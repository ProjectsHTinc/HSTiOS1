//
//  ServiceHistory.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 27/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class ServiceHistory: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var serviceListArr = [ServiceList]()
    var serviceorderid = String()
    var serviceStatus =  String()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addBackButton()
        self.preferedLanguage()
        self.webRequestServiceHistory(user_master_id: GlobalVariables.shared.user_master_id)
    }
    
    func preferedLanguage () {
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesService_text", comment: "")
    }
    
    @objc public override func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func webRequestServiceHistory(user_master_id: String) {
        let parameters = ["user_master_id": user_master_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "service_history", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
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
                            Alert.defaultManager.showOkAlert("SkilEx", message: msg) { (action) in
                                //Custom action code
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServiceHistoryTableViewCell
        let serviceList = serviceListArr[indexPath.row]

        if LocalizationSystem.sharedInstance.getLanguage() == "en"
        {
            cell.mainCategoery.text = serviceList.main_category
            cell.subcategoery.text = serviceList.service_name
            cell.date.text = serviceList.order_date
            cell.time.text = serviceList.time_slot
            cell.serviceStats.text = serviceList.order_status
            if cell.serviceStats.text == "Cancelled"
            {
                cell.serviceStatusImage.image = UIImage(named: "cancelservice")
            }
            else
            {
                cell.serviceStatusImage.image = UIImage(named: "servicesuccess")
            }
            
        }
        else
        {
            cell.mainCategoery.text = serviceList.main_category_ta
            cell.subcategoery.text = serviceList.service_ta_name
            cell.date.text = serviceList.contact_person_name
            cell.time.text = serviceList.order_date
        }
        
        cell.cellView.dropShadow(offsetX: 0, offsetY: 1, color: UIColor.gray, opacity: 0.5, radius: 6)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = serviceListArr[indexPath.row]
        serviceorderid = index.service_order_id!
        self.serviceStatus = index.order_status!
        if self.serviceStatus == "Cancelled"
        {
            self.webRequestserviceOrderSummary(service_order_id: index.service_order_id!)
        }
        else
        {
            
            self.webRequestProceedforPayment()
            self.webRequestserviceSummaryDetail(service_order_id: index.service_order_id!)
            
        }
    }
    
    func webRequestserviceOrderSummary(service_order_id: String) {
        let parameters = ["user_master_id": GlobalVariables.shared.user_master_id,"service_order_id": service_order_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "service_order_summary", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let status = json["status"].stringValue
                        let order_id = json["order_id"].stringValue
                        print(order_id)
                        if msg == "Service found" && status == "success"{

                            if json["service_list"].count > 0 {
                                let service_Summary = ServiceSummary(json: json["service_list"])
                                UserDefaults.standard.saveServiceSummary(serviceSummary: service_Summary)
                                self.performSegue(withIdentifier: "bookingDetailSummary", sender: self)
                            }
                        }
                        else
                        {
                            Alert.defaultManager.showOkAlert("SkilEx", message: msg) { (action) in
                                //Custom action code
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

   func webRequestserviceSummaryDetail(service_order_id: String) {
    let parameters = ["user_master_id": GlobalVariables.shared.user_master_id,"service_order_id": service_order_id]
    MBProgressHUD.showAdded(to: self.view, animated: true)
    DispatchQueue.global().async
        {
            do
            {
                try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "service_order_summary", params: parameters, headers: nil, success: {
                    (JSONResponse) -> Void in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    print(JSONResponse)
                    let json = JSON(JSONResponse)
                    let msg = json["msg"].stringValue
                    let status = json["status"].stringValue
                    let order_id = json["order_id"].stringValue
                    print(order_id)
                    if msg == "Service found" && status == "success"{
                        
                        if json["service_list"].count > 0 {
                            let service_Summary = ServiceSummary(json: json["service_list"])
                            UserDefaults.standard.saveServiceSummary(serviceSummary: service_Summary)
                            self.performSegue(withIdentifier: "serviceSummaryDetail", sender: self)
                        }
                    }
                    else
                    {
                        Alert.defaultManager.showOkAlert("SkilEx", message: msg) { (action) in
                            //Custom action code
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
    
    func webRequestProceedforPayment ()
    {
        let parameters = ["user_master_id": GlobalVariables.shared.user_master_id,"service_order_id": serviceorderid]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "proceed_for_payment", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let status = json["status"].stringValue
                        if msg == "Proceed for Payment" && status == "success"
                        {
                            GlobalVariables.shared.order_id = json["payment_details"]["order_id"].stringValue
                            GlobalVariables.shared.payableAmount = json["payment_details"]["payable_amount"].stringValue

                        }
                        else
                        {
                            Alert.defaultManager.showOkAlert("SkilEx", message: msg) { (action) in
                                //Custom action code
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
        return 180
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "bookingDetailSummary")
        {
            let vc = segue.destination as! ServiceDetailSummary
            vc.service_order_id = serviceorderid
        }
        else if (segue.identifier == "serviceSummaryDetail")
        {
            let vc = segue.destination as! ServiceSummaryDetail
            vc.service_order_id = serviceorderid
            vc.paymentStatus = self.serviceStatus
        }
    }
    

}
