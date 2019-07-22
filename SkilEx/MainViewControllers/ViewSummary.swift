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
    
    var cartListArr = [CartList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addBackButton()
        self.webRequestViewCart()
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
                        if msg == "Cart list found" && status == "success"{
                          
                            for i in 0..<json["cart_list"].count {
                                
                                let cartlist = CartList.init(json: json["cart_list"][i])
                                self.cartListArr.append(cartlist)
                            }
                                self.tableView.reloadData()
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
    
    @objc public override func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func proceedAction(_ sender: Any) {
        
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
