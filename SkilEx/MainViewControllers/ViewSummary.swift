//
//  ViewSummary.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 22/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class ViewSummary: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var advanceAmount: UILabel!
    @IBOutlet weak var totalServiceAmount: UILabel!
    @IBOutlet weak var proceedOutlet: UIButton!
    @IBOutlet weak var advanceAmountLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var orderSummaryLabel: UILabel!
    
    var cartListArr = [CartList]()
    var cartListServiceName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.preferedLanguage()
        self.addBackButton()
        self.webRequestViewCart()
    }
    
    override func viewWillLayoutSubviews() {
        
        proceedOutlet.addShadowToButton(color: UIColor.gray, cornerRadius: 20, backgroundcolor: UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0))
    }
    
    func preferedLanguage()
    {
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "viewsummarynavtitle_text", comment: "")
        self.advanceAmountLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "viewsummaryadvanceamount_text", comment: "")
        self.totalAmountLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "viewsummarytotalamount_text", comment: "")
        proceedOutlet.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "viewsummaryproceed_text", comment: ""), for: .normal)
        orderSummaryLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "ordersummary_text", comment: "")
    }
    
    func webRequestViewCart()
    {
        let parameters = ["user_master_id": GlobalVariables.shared.user_master_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "view_cart_summary", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let status = json["status"].stringValue
                        GlobalVariables.shared.Service_amount = json["grand_total"].stringValue
                        
                        if msg == "Cart list found" && status == "success"{
                            
                            self.advanceAmount.isHidden = false
                            self.totalServiceAmount.isHidden = false
                            self.advanceAmountLabel.isHidden = false
                            self.totalAmountLabel.isHidden = false
                            self.proceedOutlet.isHidden = false
                            self.cartListArr = []
                            
                            for i in 0..<json["cart_list"].count {
                                
                                let cartlist = CartList.init(json: json["cart_list"][i])
                                self.cartListArr.append(cartlist)
                            }
                                self.tableView.reloadData()
                        }
                        else
                        {
                            self.cartListArr = []
                            self.tableView.reloadData()
                            Alert.defaultManager.showOkAlert("SkilEx", message: msg) { (action) in
                                //Custom action code
                            }
                            self.advanceAmount.isHidden = true
                            self.advanceAmountLabel.isHidden = true
                            self.totalServiceAmount.isHidden = true
                            self.totalAmountLabel.isHidden = true
                            self.proceedOutlet.isHidden = true
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
    
    func webRequestRemoveFromCart(cartId: String)
    {
        let parameters = ["cart_id": cartId]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "remove_service_to_cart", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let status = json["status"].stringValue
                        if msg == "Service removed from cart" && status == "success"{
                            self.webRequestViewCart()
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
        return cartListArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServiceDetailTableViewCell
        let cartList = cartListArr[indexPath.row]
        if LocalizationSystem.sharedInstance.getLanguage() == "en"{
            
            cell.serviceName.text = cartList.service_name
            self.advanceAmount.text = String(format: "%@ %@", "Rs.",cartListArr[0].advance_amount!)
            self.totalServiceAmount.text = String(format: "%@ %@", "Rs.",GlobalVariables.shared.Service_amount)
            GlobalVariables.shared.rowCount = cartListArr.count
            let imgUrl = cartList.service_picture
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
            cell.serviceName.text = cartList.service_ta_name
            self.advanceAmount.text = String(format: "%@ %@", "Rs.",cartListArr[0].advance_amount!)
            self.totalServiceAmount.text = String(format: "%@ %@", "Rs.",GlobalVariables.shared.Service_amount)
            GlobalVariables.shared.rowCount = cartListArr.count
            let imgUrl = cartList.service_picture
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
        return 95
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let cartList = cartListArr[indexPath.row]
            print(cartList.cart_id!)
            self.webRequestRemoveFromCart(cartId: cartList.cart_id!)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        if LocalizationSystem.sharedInstance.getLanguage() == "en"{
            
            return "Delete"
        }
        else
        {
            return "அழி"
        }
    }
    
    @objc public override func backButtonClick() {
        
        if GlobalVariables.shared.viewPage == "ServiceResult"
        {
            self.serviceRemoveFromCart(user_master_id: GlobalVariables.shared.user_master_id)
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
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
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let status = json["status"].stringValue
                        if msg == "All Service removed from cart" && status == "success"
                        {
                             self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func proceedAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "customerAddress", sender: self)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "customerAddress"){
            let _ = segue.destination as! CustomerAddress
        }
    }
}
