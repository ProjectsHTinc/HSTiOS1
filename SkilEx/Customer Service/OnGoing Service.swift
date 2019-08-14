//
//  OnGoing Service.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 23/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class OnGoing_Service: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var serviceListArr = [ServiceList]()
    @IBOutlet weak var tableView: UITableView!
    var sevice_order_id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addBackButton()
        self.preferedLanguage()
        self.webRequestOngoingServiceList(user_master_id: GlobalVariables.shared.user_master_id)
    }
    
    func preferedLanguage () {
         self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ongoingservicenavtitle_text", comment: "")
    }

    @objc public override func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func webRequestOngoingServiceList(user_master_id: String) {
        let parameters = ["user_master_id": user_master_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "ongoing_services", params: parameters, headers: nil, success: {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OngoingServiceTableViewCell
        let serviceList = serviceListArr[indexPath.row]
        
        if LocalizationSystem.sharedInstance.getLanguage() == "en"
        {
            cell.mainCategoery.text = serviceList.main_category
            cell.subCategoery.text = serviceList.service_name
            cell.customerName.text = serviceList.contact_person_name
            cell.serviceDate.text = serviceList.order_date

        }
        else
        {
            cell.mainCategoery.text = serviceList.main_category_ta
            cell.subCategoery.text = serviceList.service_ta_name
            cell.customerName.text = serviceList.contact_person_name
            cell.serviceDate.text = serviceList.order_date
        }
        
        cell.cellView.dropShadow(offsetX: 0, offsetY: 1, color: UIColor.gray, opacity: 0.5, radius: 6)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = serviceListArr[indexPath.row]
        self.sevice_order_id = index.service_order_id!
        self.webRequestOngoingServiceOrderDetails(service_order_id: index.service_order_id!)
    }
    
    func webRequestOngoingServiceOrderDetails(service_order_id: String) {
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
                        let status = json["status"].stringValue
                        if msg == "Service found" && status == "success"{
                            
                            if json["service_list"].count > 0 {
                                let servicesDetail = ServicesListDetail(json: json["service_list"])
                                UserDefaults.standard.saveServicesDetail(servicesListDetail: servicesDetail)
                                self.performSegue(withIdentifier: "ongoingservicesDetail", sender: self)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 141
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "ongoingservicesDetail"){
            let vc = segue.destination as! OngoingServicesDetail
            vc.serviceorderId = sevice_order_id
        }
    }

}
