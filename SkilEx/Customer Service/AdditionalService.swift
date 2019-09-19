//
//  AdditionalService.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 27/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class AdditionalService: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    var serviceorderid = String()
    var additionalServiceArr = [AdditionalServiceList]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addBackButton()
        self.webRequestAdditionalServiceList(service_order_id: serviceorderid)
        self.preferedLanguage()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.preferedLanguage()
    }
    
    @objc public override func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func preferedLanguage()
    {
        self.navigationItem.title =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "additionalservicenavtitle_text", comment: "")
    }
    
    func webRequestAdditionalServiceList(service_order_id: String) {
        let parameters = ["service_order_id": service_order_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "view_addtional_service", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let msg_en = json["msg_en"].stringValue
                        let msg_ta = json["msg_ta"].stringValue
                        let status = json["status"].stringValue
                        if msg == "service found" && status == "success"{
                            
                            if json["service_list"].count > 0 {
                                
                                self.additionalServiceArr = []
                                
                                for i in 0..<json["service_list"].count {
                                    
                                    let additionalService = AdditionalServiceList.init(json: json["service_list"][i])
                                    self.additionalServiceArr.append(additionalService)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return additionalServiceArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AdditionalServiceTableViewcell
        let additionalserviceList = additionalServiceArr[indexPath.row]
        if LocalizationSystem.sharedInstance.getLanguage() == "en"
        {
            cell.serviceName.text = additionalserviceList.service_name
            cell.rateCardDetails.text = additionalserviceList.rate_card_details
            cell.serviceCharge.text = String(format: "%@ %@", "Rs.",additionalserviceList.rate_card!)
            let imgUrl = additionalserviceList.service_pic
            if imgUrl!.isEmpty == false
            {
                let url = URL(string: imgUrl!)
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.serviceImgView.image = image
                            }
                        }
                    }
                }
            }
        }
        else
        {
            cell.serviceName.text = additionalserviceList.service_ta_name
            cell.rateCardDetails.text = additionalserviceList.rate_card_details_ta
            cell.serviceCharge.text = String(format: "%@ %@", "Rs.",additionalserviceList.rate_card!)
            let imgUrl = additionalserviceList.service_pic
            if imgUrl!.isEmpty == false
            {
                let url = URL(string: imgUrl!)
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.serviceImgView.image = image
                            }
                        }
                    }
                }
            }
        }
        
        cell.cellView.dropShadow(offsetX: 0, offsetY: 1, color: UIColor.gray, opacity: 0.5, radius: 4)
  
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
