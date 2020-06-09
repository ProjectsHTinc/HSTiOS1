//
//  ServiceDetail.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 04/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
import HMSegmentedControl


class ServiceDetail: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    var segmentedControl1: HMSegmentedControl?
    var main_cat_id = String()
    var sub_cat_id = String()
    var subcategoeryNameArr = [String]()
    var subcategoeryIDArr = [String]()
    var serviceArr = [Services]()
    var service_nameArr = [String]()
    var serviceID = String()
    var serviceIDArr = [String]()
    var isServiceAddButtonIsClicked = false
    var lastSelectedIndex = Int()
    var selectedSegementIndex = Int()
    var selectedRowIndex = -1
    var indexArray  : [NSIndexPath]?
    var serviceCount = String()
    
    @IBOutlet weak var viewSummaryLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var serviceCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.addBackButton()
        self.hideNavigationBarBorderLine()
        let viewWidth = view.frame.width
        segmentedControl1 = HMSegmentedControl(sectionTitles: subcategoeryNameArr)
        segmentedControl1!.autoresizingMask = [.flexibleRightMargin, .flexibleWidth]
        segmentedControl1?.frame = CGRect(x: 0, y: 0, width: viewWidth, height: 50)
        segmentedControl1?.segmentEdgeInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        segmentedControl1?.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
        segmentedControl1?.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        segmentedControl1?.backgroundColor = UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255.0, alpha: 1.0)

//      let font = UIFont.systemFont(ofSize: 14)
        segmentedControl1?.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 14)!,NSAttributedString.Key.foregroundColor: UIColor(red: 229.0/255, green: 229.0/255, blue: 229.0/255.0, alpha: 1.0)]
//      segmentedControl1?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl1?.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl1?.selectionIndicatorColor = UIColor.white
        segmentedControl1?.isVerticalDividerEnabled = false
        segmentedControl1!.verticalDividerColor = UIColor.black
        segmentedControl1!.verticalDividerWidth = 0
        segmentedControl1!.segmentWidthStyle = HMSegmentedControlSegmentWidthStyle.fixed
        segmentedControl1!.selectionIndicatorHeight = 2.0
        segmentedControl1!.indexChangeBlock = { index in
            print(String(format: "Selected index %ld (via block)", index))
        }
        segmentedControl1?.addTarget(self, action: #selector(segmentedControlChangedValue(_:)), for: .valueChanged)
        view.addSubview(segmentedControl1!)
        
//        sub_cat_id = self.subcategoeryIDArr[0]
//        self.webRequestServiceList(Index: sub_cat_id)
        lastSelectedIndex = 0
        self.indexArray = []
        GlobalVariables.shared.viewPage = "ServiceDetail"
        self.preferedLanguage()
        self.serviceCount = "0"

    }
    
    func hideNavigationBarBorderLine ()
    {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        sub_cat_id = self.subcategoeryIDArr[0]
        self.webRequestServiceList(Index: sub_cat_id)
        self.segmentedControl1?.selectedSegmentIndex = 0
        self.serviceCount = "0"
        self.indexArray = []
        self.preferedLanguage()
    }
    
    func preferedLanguage()
    {
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicedetailnav_text", comment: "")
        serviceCountLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicedetailservice_text", comment: "")
        viewSummaryLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicedetailsummary_text", comment: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func segmentedControlChangedValue(_ segmentedControl: HMSegmentedControl?)
    {
        print(String(format: "Selected index %ld (via UIControlEventValueChanged)", Int(segmentedControl?.selectedSegmentIndex ?? 0)))
        print(self.serviceCount)
        if (sub_cat_id == "0")
        {
            sub_cat_id = self.subcategoeryIDArr[Int(segmentedControl?.selectedSegmentIndex ?? 0)]
            self.webRequestServiceList(Index:sub_cat_id)
        }
        else
        {
            if (self.serviceCount != "0")
            {
                let alertController = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicedetailalertnextcatgoery", comment: ""), preferredStyle: UIAlertController.Style.alert)
                
                
                let okAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "confirmalert", comment: ""), style: UIAlertAction.Style.default)
                {
                    UIAlertAction in
                    self.isServiceAddButtonIsClicked = false
                    self.serviceCount = "0"
                    self.serviceRemoveFromCart(user_master_id: GlobalVariables.shared.user_master_id)
                    self.selectedSegementIndex = Int(segmentedControl?.selectedSegmentIndex ?? 0)
                    self.lastSelectedIndex = Int(segmentedControl?.selectedSegmentIndex ?? 0)
                    self.sub_cat_id = self.subcategoeryIDArr[Int(segmentedControl?.selectedSegmentIndex ?? 0)]
                    self.webRequestServiceList(Index:self.sub_cat_id)

                }
                let cancelAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "cancelcart", comment: ""), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.segmentedControl1?.selectedSegmentIndex = self.lastSelectedIndex
                }
                
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else
            {
                self.sub_cat_id = self.subcategoeryIDArr[Int(segmentedControl?.selectedSegmentIndex ?? 0)]
                self.webRequestServiceList(Index:self.sub_cat_id)

            }
        }
    }
    
    func webRequestServiceList (Index:String)
    {
            let url = AFWrapper.BASE_URL + "services_list"
            let parameters = ["main_cat_id": main_cat_id, "sub_cat_id": Index, "user_master_id":GlobalVariables.shared.user_master_id]
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
                            let msg_en = json["msg_en"].stringValue
                            let msg_ta = json["msg_ta"].stringValue
                            let status = json["status"].stringValue
                            if msg == "View Services" && status == "success"
                            {
                                if json["services"].count > 0
                                {
                                    
                                    self.serviceArr.removeAll()
                                    self.service_nameArr.removeAll()
                                    self.serviceIDArr.removeAll()
                                    
                                    for i in 0..<json["services"].count
                                    {
                                        let services = Services.init(json: json["services"][i])
                                        self.serviceArr.append(services)
                                        let service_name = services.service_name
                                        self.service_nameArr.append(service_name!)
                                        let service_id = services.service_id
                                        self.serviceIDArr.append(service_id!)
                                        let selected = services.selected
                                        if selected != "0"
                                        {
                                            let myIndexPath = NSIndexPath(row: i, section: 0)
                                            self.indexArray?.append(myIndexPath as NSIndexPath)
                                            self.serviceCount = String(GlobalVariables.shared.rowCount)
                                            self.UpdateServiceCountandCost(serviceCount:self.serviceCount, amount: GlobalVariables.shared.Service_amount)
                                        }
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
                                self.serviceArr.removeAll()
                                self.service_nameArr.removeAll()
                                self.serviceIDArr.removeAll()
                                self.tableView .reloadData()
                                self.isServiceAddButtonIsClicked = false
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return serviceArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServiceDetailTableViewCell
        
        if (self.indexArray?.contains(indexPath as NSIndexPath))!
        {
            if LocalizationSystem.sharedInstance.getLanguage() == "en"
            {
                cell.tickImage.isHidden = false
                cell.addImage.isHidden = true
                cell.addLabel.isHidden = true
                cell.addLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicedetailadd_text", comment: "")
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
                cell.selectionBackgroundView.backgroundColor =  UIColor(red: 142.0/255, green: 198.0/255, blue: 65.0/255, alpha: 1.0)
                cell.addButton.tag = indexPath.row
                cell.addButton.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
            }
            else
            {
                cell.tickImage.isHidden = false
                cell.addImage.isHidden = true
                cell.addLabel.isHidden = true
                cell.addLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicedetailadd_text", comment: "")
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

                cell.selectionBackgroundView.backgroundColor =  UIColor(red: 142.0/255, green: 198.0/255, blue: 65.0/255, alpha: 1.0)
                cell.addButton.tag = indexPath.row
                cell.addButton.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
            }
        }
        else
        {
            if LocalizationSystem.sharedInstance.getLanguage() == "en"
            {
                cell.tickImage.isHidden = true
                cell.addImage.isHidden = false
                cell.addLabel.isHidden = false
                cell.addLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicedetailadd_text", comment: "")
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
                cell.selectionBackgroundView.backgroundColor =  UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0)
                cell.addButton.tag = indexPath.row
                cell.addButton.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
            }
            else
            {
                cell.tickImage.isHidden = true
                cell.addImage.isHidden = false
                cell.addLabel.isHidden = false
                cell.addLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicedetailadd_text", comment: "")
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
                cell.selectionBackgroundView.backgroundColor =  UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0)
                cell.addButton.tag = indexPath.row
                cell.addButton.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
            }
        }
        return cell
    }
    
    
    @objc func buttonSelected(sender: UIButton)
    {
           print(sender.tag)
           let myIndexPath = NSIndexPath(row: sender.tag, section: 0)
           if ((indexArray?.contains(myIndexPath))!)
           {
            let indexOfA = indexArray?.firstIndex(of: myIndexPath)
            print("YES",indexOfA as Any)
            self.indexArray?.remove(at: indexOfA!)
            let cell = tableView.cellForRow(at: myIndexPath as IndexPath) as! ServiceDetailTableViewCell
            cell.selectionBackgroundView.backgroundColor =  UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0)
            cell.addImage.isHidden = false
            cell.addLabel.isHidden = false
            cell.tickImage.isHidden = true
            self.removeServiceFromCart(user_master_id: GlobalVariables.shared.user_master_id, category_id: main_cat_id, sub_category_id: sub_cat_id, service_id: serviceIDArr[myIndexPath.row])

           }
           else
           {
            isServiceAddButtonIsClicked = true
            self.indexArray?.append((myIndexPath as NSIndexPath))
            print(indexArray as Any)
            let cell = tableView.cellForRow(at: myIndexPath as IndexPath) as! ServiceDetailTableViewCell
            self.serviceAddToCart(user_master_id: GlobalVariables.shared.user_master_id, category_id: main_cat_id, sub_category_id: sub_cat_id, service_id: serviceIDArr[myIndexPath.row])
            cell.selectionBackgroundView.backgroundColor =  UIColor(red: 142.0/255, green: 198.0/255, blue: 65.0/255, alpha: 1.0)
            cell.addImage.isHidden = true
            cell.addLabel.isHidden = true
            cell.tickImage.isHidden = false
           }
    }
    
    func serviceAddToCart(user_master_id: String, category_id: String, sub_category_id: String, service_id:String)
    {
        if user_master_id.isEmpty == true
        {
            let alertController = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "homealertmsg_text", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            
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
            let url = AFWrapper.BASE_URL + "add_service_to_cart"
            let parameters = ["user_master_id": user_master_id, "category_id": category_id, "sub_category_id": sub_category_id, "service_id": service_id]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            DispatchQueue.global().async
                {
                    do
                    {
                        try AFWrapper.requestPOSTURL(url, params: (parameters), headers: nil, success: {
                            (JSONResponse) -> Void in
                            print(JSONResponse)
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let json = JSON(JSONResponse)
                            let msg = json["msg"].stringValue
//                            let msg_en = json["msg_en"].stringValue
//                            let msg_ta = json["msg_ta"].stringValue
                            let status = json["status"].stringValue
                            if msg == "Service added to cart" && status == "success"
                            {
                                let cart_total = json["cart_total"]
                                print(cart_total as Any)
                                self.serviceCount = cart_total["service_count"].stringValue
                                GlobalVariables.shared.Service_amount = cart_total["total_amt"].stringValue
                                self.UpdateServiceCountandCost(serviceCount: self.serviceCount , amount: GlobalVariables.shared.Service_amount)
                            }
                            else
                            {
//                                if LocalizationSystem.sharedInstance.getLanguage() == "en"
//                                {
//                                    Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_en) { (action) in
//                                        // Custom action code
//                                   }
//                                }
//                                else
//                                {
//                                    Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_ta) { (action) in
//                                        // Custom action code
//                                     }
//                                }
//                                self.UpdateServiceCountandCost(serviceCount: "2" , amount: "2")

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
    
    func removeServiceFromCart(user_master_id: String, category_id: String, sub_category_id: String, service_id:String)
    {
        if user_master_id.isEmpty == true
        {
           let alertController = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "homealertmsg_text", comment: ""), preferredStyle: UIAlertController.Style.alert)
           
           
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
           let url = AFWrapper.BASE_URL + "remove_service_from_cart"
           let parameters = ["user_master_id": user_master_id, "category_id": category_id, "sub_category_id": sub_category_id, "service_id": service_id]
           MBProgressHUD.showAdded(to: self.view, animated: true)
           DispatchQueue.global().async
               {
                   do
                   {
                       try AFWrapper.requestPOSTURL(url, params: (parameters), headers: nil, success: {
                           (JSONResponse) -> Void in
                           print(JSONResponse)
                           MBProgressHUD.hide(for: self.view, animated: true)
                           let json = JSON(JSONResponse)
                           let msg = json["msg"].stringValue
                           let msg_en = json["msg_en"].stringValue
                           let msg_ta = json["msg_ta"].stringValue
                           let status = json["status"].stringValue
                           if msg == "Service added to cart" && status == "success"
                           {
                               let cart_total = json["cart_total"]
                               print(cart_total as Any)
                               self.serviceCount = cart_total["service_count"].stringValue
                               GlobalVariables.shared.Service_amount = cart_total["total_amt"].stringValue
                               self.UpdateServiceCountandCost(serviceCount: self.serviceCount , amount: GlobalVariables.shared.Service_amount)
                           }
                           else
                           {
                               if LocalizationSystem.sharedInstance.getLanguage() == "en"
                               {
                                   Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_en) { (action) in
                                       // Custom action code
                                  }
                               }
                               else
                               {
                                   Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_ta) { (action) in
                                       // Custom action code
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
    }
    
    func UpdateServiceCountandCost(serviceCount:String, amount:String)
    {
        if (serviceCount == "0")
        {
             self.serviceCountLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicedetailservice_text", comment: "")
        }
        else
        {
            self.serviceCountLabel.text = String(format: "%@%@%@ | %@%@", LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicedetailservice_text", comment: ""),":", serviceCount,"₹.",amount)
        }
    }
    
    func serviceRemoveFromCart(user_master_id: String)
    {
        let url = AFWrapper.BASE_URL + "clear_cart"
        let parameters = ["user_master_id": user_master_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(url, params: (parameters), headers: nil, success: {
                        (JSONResponse) -> Void in
                        print(JSONResponse)
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let status = json["status"].stringValue
                        if msg == "All Service removed from cart" && status == "success"
                        {
                            self.UpdateServiceCountandCost(serviceCount: "0" , amount: "0")
                            self.indexArray = []
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let index = serviceArr[indexPath.row]
        serviceID = index.service_id!
        GlobalVariables.shared.catServicetID = serviceID
        GlobalVariables.shared.main_catID = main_cat_id
        GlobalVariables.shared.sub_catID = sub_cat_id
        GlobalVariables.shared.serviceId = serviceID
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    @objc public override func backButtonClick()
    {
        if (self.serviceCount == "0")
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            let alertController = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicespageBack_text", comment: ""), preferredStyle: UIAlertController.Style.alert)
                    
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                UIAlertAction in

                self.serviceRemoveFromCart(user_master_id: GlobalVariables.shared.user_master_id)
                self.navigationController?.popViewController(animated: true)

            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                UIAlertAction in
            }
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    @IBAction func viewSummaryButton(_ sender: Any)
    {
        if GlobalVariables.shared.user_master_id.isEmpty == true
        {
              let alertController = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "homealertmsg_text", comment: ""), preferredStyle: UIAlertController.Style.alert)
                         
                         
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
            if (self.serviceCount == "0")
            {
                Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicescartmsg_text", comment: "")) { (action) in
                                   
                }
            }
            else
            {
               self.performSegue(withIdentifier: "viewSummary", sender: self)
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
        else if (segue.identifier == "viewSummary")
        {
            let _ = segue.destination as! ViewSummary
        }
        else if (segue.identifier == "to_Login")
        {
            let _ = segue.destination as! Login
        }
    }
}
