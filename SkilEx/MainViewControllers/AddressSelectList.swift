//
//  AddressSelectList.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 04/12/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class AddressSelectList: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
     
    var addressArr = [AddressList]()
    var contactName = [String]()
    var ContactNumber = [String]()
    var addressid = [String]()
    var serviceAddress = [String]()
    var ServiceLat_Long = [String]()
    var serviceLocation = [String]()
    var addresses = [String]()
    var imageArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        addresses = ["Address 1","Address 2"]
        imageArray = ["edit_address","edit_address"]
        
        self.addBackButton()
        self.preferedLanguage()
        self.adressList()
    }
    
    @objc public override func backButtonClick()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func preferedLanguage()
    {
       
    }
    
    func adressList ()
    {

        let parameters = ["cust_id":GlobalVariables.shared.user_master_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "customer_address_list", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        
                        let msg = json["msg"].stringValue
                        let status = json["status"].stringValue
                        if  status == "success"
                        {
                            if json["address_list"].count > 0 {
                                
                                for i in 0..<json["address_list"].count {
                                    let adress = AddressList.init(json: json["address_list"][i])
                                    self.addressArr.append(adress)
                                    let contName = adress.contact_name
                                    self.contactName.append(contName!)
                                    
                                    let contNum = adress.contact_no
                                    self.ContactNumber.append(contNum!)
                                    
                                    let serAdress = adress.serv_address
                                    self.serviceAddress.append(serAdress!)
                                    
                                    let adressId = adress.id
                                    self.addressid.append(adressId!)
                                    
                                    let serLatLong = adress.serv_lat_lon
                                    self.ServiceLat_Long.append(serLatLong!)
                                    
                                    let serLoc = adress.serv_loc
                                    self.serviceLocation.append(serLoc!)
                                }
                                    
                                    self.tableView.reloadData()
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
        return addressArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomerAdressEditCell
        let addresService = addressArr[indexPath.row]
        cell.custNameLabel.text =  addresService.contact_name
        cell.custphoneNoLabel.text =  addresService.contact_no
        cell.custCityLabel.text =  addresService.serv_loc
        cell.CustAddressLabel.text =  addresService.serv_address
        cell.addressLabel.text = addresses[indexPath.row]
        cell.editImage.image = UIImage(named:imageArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let VC = storyboard?.instantiateViewController(withIdentifier:"CustomerAdressEdit")as! CustomerAdressEdit
        VC.contact_Name = addressArr[indexPath.row].contact_name!
        VC.Phone_Number = addressArr[indexPath.row].contact_no!
        VC.seviceId = addressArr[indexPath.row].id!
        VC.seviceAdress = addressArr[indexPath.row].serv_loc!
        VC.serviceLocation = addressArr[indexPath.row].serv_address!
        VC.seviceLatLong = addressArr[indexPath.row].serv_lat_lon!
        
            self.navigationController?.pushViewController(VC,animated:true)
       
    }

}
