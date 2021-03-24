
//
//  ChooseAddress.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 07/12/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

protocol addressListDelegate
{
    func saveText(conName: String,conNum:String,conLoc: String,conAddress:String,conLat_Long:String)
}

class ChooseAddress: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subitButton: UIButton!
    @IBOutlet weak var chooseAddresslbl: UILabel!
    
    var addressArr = [AddressList]()
    var contactName = [String]()
    var ContactNumber = [String]()
    var addressid = [String]()
    var serviceAddress = [String]()
    var ServiceLat_Long = [String]()
    var serviceLocation = [String]()
    var addresses = [String]()
    
    var delegate : addressListDelegate?
    var strconName : NSString!
    var strconNum : NSString!
    var strconLoc : NSString!
    var strconAddress : NSString!
    var strconLat_Long : NSString!
    var selectedIndex: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addresses = ["Address 1","Address 2"]
        self.adressList()
        tableView.dataSource = self

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.presentingViewController?.view.alpha = 1
    }
    
    @IBAction func close(_ sender: Any) {
       
    self.dismiss(animated: true, completion: nil)
  
    }
    
    @IBAction func submitButton(_ sender: Any) {
        if (self.delegate) != nil
        {
            (delegate?.saveText(conName:(strconName as NSString) as String,conNum:(strconNum as NSString) as String,conLoc:(strconLoc as NSString) as String,conAddress:(strconAddress as NSString) as String,conLat_Long:(strconLat_Long as NSString) as String))!
           self.dismiss(animated: true, completion: nil)
        }
    }
    
    func adressList ()
    {
        let parameters = ["cust_id":GlobalVariables.shared.user_master_id ]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChooseAddressCell
        let addresService = addressArr[indexPath.row]
        cell.custNameLabel.text =  addresService.contact_name
        cell.custphoneNoLabel.text =  addresService.contact_no
        cell.custCityLabel.text =  addresService.serv_loc
        cell.CustAddressLabel.text =  addresService.serv_address
        cell.addressLabel.text = addresses[indexPath.row]
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        selectedIndex = indexPath.row;
        let adresslist = addressArr[selectedIndex]
        self.strconName = String (adresslist.contact_name!) as NSString
        self.strconNum = String (adresslist.contact_no!) as NSString
        self.strconLoc = String (adresslist.serv_loc!) as NSString
        self.strconAddress = String (adresslist.serv_address!) as NSString
        self.strconLat_Long = String (adresslist.serv_lat_lon!) as NSString
    
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
     
        tableView.cellForRow(at: indexPath)?.accessoryType = .none

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

      }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "customerAddress"){
            
            let _ = segue.destination as! CustomerAddress
        }
    }
}
