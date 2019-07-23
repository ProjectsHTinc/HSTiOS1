//
//  SearchResult.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 23/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class SearchResult: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var searchText = String()
    var serviceArr = [Services]()
    var service_nameArr = [String]()
    var serviceID = String()
    var serviceIDArr = [String]()
    var main_cat_id = String()
    var sub_cat_id = String()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addBackButton()
        self.preferedLanguage()
        self.webRequestSearchList(searchtext:searchText)
        GlobalVariables.shared.viewPage = "ServiceResult"

    }
    
    func preferedLanguage(){
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "searchresultnavtitle_text", comment: "")
    }
    
    @objc public override func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func webRequestSearchList(searchtext: String){
        
        let parameters = ["service_txt": searchtext, "service_txt_ta": "", "user_master_id": GlobalVariables.shared.user_master_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "search_service", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let status = json["status"].stringValue
                        if msg == "View Services" && status == "success"{
                         
                            if json["services"].count > 0 {
                                
                                self.serviceArr.removeAll()
                                self.service_nameArr.removeAll()
                                self.serviceIDArr.removeAll()
                                
                                for i in 0..<json["services"].count {
                                    
                                    let services = Services.init(json: json["services"][i])
                                    self.serviceArr.append(services)
                                    let service_name = services.service_name
                                    self.service_nameArr.append(service_name!)
                                    let service_id = services.service_id
                                    self.serviceIDArr.append(service_id!)
                                }
                                    self.tableView .reloadData()
                            }
                        }
                        else
                        {
                            Alert.defaultManager.showOkAlert("SkilEx", message: msg) { (action) in
                                
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
        return serviceArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServiceDetailTableViewCell
        
        if LocalizationSystem.sharedInstance.getLanguage() == "en"
        {
            let service = serviceArr[indexPath.row]
            cell.serviceName.text =  service.service_name
            let imgUrl = service.service_pic_url
            if imgUrl!.isEmpty == false
            {
                let url = URL(string: imgUrl!)
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.serviceImageView.image = image
                            }
                        }
                    }
                }
            }
        }
        else
        {
            let service = serviceArr[indexPath.row]
            cell.serviceName.text =  service.service_ta_name
            let imgUrl = service.service_pic_url
            if imgUrl!.isEmpty == false
            {
                let url = URL(string: imgUrl!)
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.serviceImageView.image = image
                            }
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 117
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let index = serviceArr[indexPath.row]
        serviceID = index.service_id!
        GlobalVariables.shared.catServicetID = serviceID
        GlobalVariables.shared.main_catID = main_cat_id
        GlobalVariables.shared.sub_catID = sub_cat_id
        if serviceID.isEmpty == false
        {
            let url = AFWrapper.BASE_URL + "service_details"
            let parameters = ["service_id": serviceID]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            DispatchQueue.global().async
                {
                    do
                    {
                        try AFWrapper.requestPOSTURL(url, params: (parameters), headers: nil, success: {
                            (JSONResponse) -> Void in
                            MBProgressHUD.hide(for: self.view, animated: true)
                            print(JSONResponse)
                            let json = JSON(JSONResponse)
                            let msg = json["msg"].stringValue
                            let status = json["status"].stringValue
                            if msg == "Service Details" && status == "success"
                            {
                                let servicesdescripition = ServicesDescripition(json: json["service_details"])
                                UserDefaults.standard.saveServicesDescripition(servicesDescripition: servicesdescripition)
                                GlobalVariables.shared.Service_amount = servicesdescripition.rate_card!
                                self.performSegue(withIdentifier: "serviceDescrption", sender: self)
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
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "serviceDescrption") {
            let _ = segue.destination as! ServiceDescripition
        }
    }
    

}
