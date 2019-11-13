//
//  ServiceSummary.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 28/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD


class ServiceSummaryDetail: UITableViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate{
    
    @IBOutlet weak var mainCategoery: UILabel!
    @IBOutlet weak var subCategoery: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var serviceDateLabel: UILabel!
    @IBOutlet weak var serviceDate: UILabel!
    @IBOutlet weak var requestedTimeLabel: UILabel!
    @IBOutlet weak var requestedTime: UILabel!
    @IBOutlet weak var serviceProviderLabel: UILabel!
    @IBOutlet weak var serviceProvider: UILabel!
    @IBOutlet weak var servicePersonLabel: UILabel!
    @IBOutlet weak var servicePerson: UILabel!
    @IBOutlet weak var serviceStartedLabel: UILabel!
    @IBOutlet weak var serviceStartDate: UILabel!
    @IBOutlet weak var serviceStartTime: UILabel!
    @IBOutlet weak var serviceCompletedLabel: UILabel!
    @IBOutlet weak var serviceCompletedDate: UILabel!
    @IBOutlet weak var additionalServiceTextField: UITextField!
    @IBOutlet weak var materialUsedLabel: UILabel!
    @IBOutlet weak var materialUsedTextView: UITextView!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var serviceChargeLabel: UILabel!
    @IBOutlet weak var serviceCharge: UILabel!
    @IBOutlet weak var additionalServiceChargeLabel: UILabel!
    @IBOutlet weak var additionalServiceCharge: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var couponLabel: UILabel!
    @IBOutlet weak var coupon: UILabel!
    @IBOutlet weak var advanceAmountLabel: UILabel!
    @IBOutlet weak var advanceAmount: UILabel!
    @IBOutlet weak var grandTotalLabel: UILabel!
    @IBOutlet weak var grandTotal: UILabel!
    @IBOutlet weak var paidOutlet: UIButton!
    @IBOutlet weak var viewBillLabel: UILabel!
    @IBOutlet weak var couponTextField: UITextField!
    @IBOutlet weak var applyCouponOutlet: UIButton!
    @IBOutlet weak var serviceCompletedTime: UILabel!
    
    var service_order_id = String()
    var paymentStatus = String()
//    var payable_amount = String()
    let picker = UIPickerView()
    var couponOffers = [String]()
    var couponID = [String]()
    var coupon_id = String()
    var orderStatus = String()
    var iscouponApplied = false
    var showRow = Int()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.webRequestProceedforPayment ()
        self.addBackButton()
        self.couponTextField.borderColor = UIColor.black
        self.couponTextField.borderWidth = 1.0
        self.couponTextField.clipsToBounds = true
        self.showPickerView()
        self.updateValues()
        self.webRequestCouponList()
        self.serviceStatusCheck (user_master_id: GlobalVariables.shared.user_master_id, service_order_id: service_order_id)
        self.preferedLanguage()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.preferedLanguage()

    }
    
    override func viewWillLayoutSubviews() {
        paidOutlet.addShadowToButton(color: UIColor.gray, cornerRadius: 16, backgroundcolor: UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0))
    }
    
    func preferedLanguage () {
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicehistorysummarynavtitle_text", comment: "")
        self.customerNameLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicehistorysummarycustomername_text", comment: "")
        self.serviceDateLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicehistorysummaryservicedate_text", comment: "")
        self.requestedTimeLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicehistorysummaryrequestedtime_text", comment: "")
        self.serviceProviderLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicehistorysummaryserviceprovider_text", comment: "")
        self.servicePersonLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicehistorysummaryserviceperson_text", comment: "")
        self.serviceStartedLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicehistorysummaryservicestarted_text", comment: "")
        self.serviceCompletedLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicehistorysummaryservicecompleted_text", comment: "")
        self.materialUsedLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicehistorysummarymaterialsused_text", comment: "")
        self.paymentLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicehistorysummarypayment_text", comment: "")
        self.serviceChargeLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicehistorysummaryservicecharge_text", comment: "")
        self.additionalServiceChargeLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "serviceadditional_text", comment: "")
        self.couponLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicehistorysummarycouponapplied_text", comment: "")
        self.subTotalLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicehistorysummarysubtotal_text", comment: "")
        self.advanceAmountLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicehistorysummaryadvanceamount_text", comment: "")
        self.grandTotalLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicehistorysummarygrandtotal_text", comment: "")
        self.viewBillLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicehistorysummaryviewbill_text", comment: "")
        self.couponTextField.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "serviceentercouponcode_text", comment: "")
        self.applyCouponOutlet.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "serviceapply_text", comment: ""), for: .normal)
        self.paidOutlet.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicehistorybutton_text", comment: ""), for: .normal)
    }
    
    
    @objc public override func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateValues ()
    {
        let bookingDetailSummary = UserDefaults.standard.getServiceSummary()

        if LocalizationSystem.sharedInstance.getLanguage() == "en"
        {
            self.mainCategoery.text = bookingDetailSummary?.main_category
            self.subCategoery.text = bookingDetailSummary?.service_name
            self.customerName.text = bookingDetailSummary?.contact_person_name
            self.serviceDate.text = bookingDetailSummary?.order_date
            self.requestedTime.text = bookingDetailSummary?.time_slot
            self.serviceProvider.text = bookingDetailSummary?.provider_name
            self.servicePerson.text = bookingDetailSummary?.person_name
            let starTime = bookingDetailSummary?.service_start_time
            if (starTime!.isEmpty != true)
            {
                let starTimeArr = starTime!.components(separatedBy: " ")
                let startdate = starTimeArr[0]
                let start_time = starTimeArr[1]
                let s_time = starTimeArr[2]
                self.serviceStartDate.text = startdate
                self.serviceStartTime.text = String(format: "%@ %@", start_time,s_time)
            }
            let endTime  = bookingDetailSummary?.service_end_time
            if (endTime!.isEmpty != true)
            {
                let endTimeArr = endTime!.components(separatedBy: " ")
                let enddate = endTimeArr[0]
                let end_time = endTimeArr[1]
                let e_time = endTimeArr[2]
                self.serviceCompletedDate.text = enddate
                self.serviceCompletedTime.text =  String(format: "%@ %@", end_time,e_time)
            }
            self.additionalServiceTextField.text = String(format: "%@ - %@", LocalizationSystem.sharedInstance.localizedStringForKey(key: "serviceadditional_text", comment: ""),bookingDetailSummary!.additional_service!)
            self.materialUsedTextView.text = bookingDetailSummary?.material_notes
            self.serviceCharge.text = bookingDetailSummary?.service_amount
            self.additionalServiceCharge.text = bookingDetailSummary?.additional_service_amt
            self.advanceAmount.text = bookingDetailSummary?.paid_advance_amt
            self.coupon.text = bookingDetailSummary?.discount_amt
            self.subTotal.text = bookingDetailSummary?.total_service_cost
            let coupon_id = bookingDetailSummary?.coupon_id
            if coupon_id == "0"
            {
                let payableAmount = GlobalVariables.shared.payableAmount
                let myFloat = (payableAmount as NSString).floatValue
                self.grandTotal.text = String (myFloat)
                self.coupon.text = bookingDetailSummary?.discount_amt
                iscouponApplied = false
            }
            else
            {
                self.couponTextField.text = bookingDetailSummary?.coupon_code
                let payableAmount = GlobalVariables.shared.payableAmount
                let myFloat = (payableAmount as NSString).floatValue
                self.grandTotal.text = String (myFloat)
                self.coupon.text = bookingDetailSummary?.discount_amt
                iscouponApplied = true
            }
            
            if iscouponApplied == false
            {
                self.applyCouponOutlet.setTitle("Apply", for: .normal)
            }
            else
            {
                self.applyCouponOutlet.setTitle("Cancel", for: .normal)
            }
        }
        else
        {
            self.mainCategoery.text = bookingDetailSummary?.main_category_ta
            self.subCategoery.text = bookingDetailSummary?.service_ta_name
            self.customerName.text = bookingDetailSummary?.contact_person_name
            self.serviceDate.text = bookingDetailSummary?.order_date
            self.requestedTime.text = bookingDetailSummary?.time_slot
            self.serviceProvider.text = bookingDetailSummary?.provider_name
            self.servicePerson.text = bookingDetailSummary?.person_name
            let starTime = bookingDetailSummary?.service_start_time
            if (starTime?.isEmpty != true)
            {
                let starTimeArr = starTime!.components(separatedBy: " ")
                let startdate = starTimeArr[0]
                let start_time = starTimeArr[1]
                let time = starTimeArr[2]
                self.serviceStartDate.text = startdate
                self.serviceStartTime.text = String(format: "%@ %@", start_time,time)
            }
            let endTime  = bookingDetailSummary?.service_end_time
            if (endTime!.isEmpty != true)
            {
                let endTimeArr = endTime!.components(separatedBy: " ")
                let enddate = endTimeArr[0]
                let end_time = endTimeArr[1]
                let e_time = endTimeArr[2]
                self.serviceCompletedDate.text = enddate
                self.serviceCompletedTime.text = String(format: "%@ %@", end_time, e_time)
            }
        
            self.additionalServiceTextField.text = String(format: "%@ - %@",  LocalizationSystem.sharedInstance.localizedStringForKey(key: "serviceadditional_text", comment: ""),bookingDetailSummary!.additional_service!)
            self.materialUsedTextView.text = bookingDetailSummary?.material_notes
            self.serviceCharge.text = bookingDetailSummary?.service_amount
            self.additionalServiceCharge.text = bookingDetailSummary?.additional_service_amt
            self.coupon.text = bookingDetailSummary?.discount_amt
            self.advanceAmount.text = bookingDetailSummary?.paid_advance_amt
            self.subTotal.text = bookingDetailSummary?.total_service_cost
            let coupon_id = bookingDetailSummary?.coupon_id
            if coupon_id == "0"
            {
                let payableAmount = GlobalVariables.shared.payableAmount
                let myFloat = (payableAmount as NSString).floatValue
                self.grandTotal.text = String (myFloat)
                self.coupon.text = bookingDetailSummary?.discount_amt
                iscouponApplied = false
            }
            else
            {
                let payableAmount = GlobalVariables.shared.payableAmount
                let myFloat = (payableAmount as NSString).floatValue
                self.grandTotal.text = String (myFloat)
                self.coupon.text = bookingDetailSummary?.discount_amt
                iscouponApplied = true
            }
            
                if iscouponApplied == false
                {
                    self.applyCouponOutlet.setTitle("Apply", for: .normal)
                }
                else
                {
                self.applyCouponOutlet.setTitle("Cancel", for: .normal)
                }
        }
    }
    
    func webRequestCouponList ()
    {
        let parameters = ["user_master_id": GlobalVariables.shared.user_master_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "service_coupon_list", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let msg_en = json["msg_ta"].stringValue
                        let msg_ta = json["msg_ta"].stringValue
                        let status = json["status"].stringValue
                        let order_id = json["order_id"].stringValue
                        print(order_id)
                        if msg == "Offers found" && status == "success"{
                            
                            if json["offer_details"].count > 0 {
                                
                                for i in 0..<json["offer_details"].count {
                                    
                                    let coupon_offers = CouponOffers.init(json: json["offer_details"][i])
                                    self.couponOffers.append(coupon_offers.offer_code!)
                                    self.couponID.append(coupon_offers.id!)
                                }
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
    
    
    func showPickerView(){
        
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        toolbar.tintColor = UIColor.black
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        couponTextField.inputAccessoryView = toolbar
        couponTextField.inputView = picker
    }
    
    @objc func donePicker(){
        let row = picker.selectedRow(inComponent: 0)
        self.picker.selectRow(row, inComponent: 0, animated: false)
        self.couponTextField.text = couponOffers[row]
        coupon_id = couponID[row]
        print(coupon_id)
//        self.updateValues()
        self.couponTextField.resignFirstResponder()
    }
    
    @objc func cancelPicker(){
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return couponOffers.count
    }
    
    //MARK:- UIPickerViewDelegates methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return couponOffers[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.couponTextField.text = couponOffers[row]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  self.showRow
    }
    
    @IBAction func additionalServiceAction(_ sender: Any)
    {
        let bookingDetailSummary = UserDefaults.standard.getServiceSummary()
        let additionalService = bookingDetailSummary?.additional_service
        if additionalService == "0"
        {
            Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "additionalservicealert", comment: "")) { (action) in
            }
        }
        else
        {
            self.performSegue(withIdentifier: "additionalService", sender: self)
        }
    }
    
    @IBAction func viewBillAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "bill", sender: self)
    }
    
    @IBAction func payNowAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "paymentMethod", sender: self)
    }
    
    @IBAction func applyCouponAction(_ sender: Any)
    {
        if iscouponApplied == false
        {
            self.applyCoupon()
            iscouponApplied = true
        }
        else
        {
            self.cancelCoupon()
            iscouponApplied = false

        }
    }
    
    func applyCoupon ()
    {
        let parameters = ["user_master_id": GlobalVariables.shared.user_master_id, "coupon_id": coupon_id, "service_order_id": service_order_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "apply_coupon_to_order", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let msg_en = json["msg_ta"].stringValue
                        let msg_ta = json["msg_ta"].stringValue
                        let status = json["status"].stringValue
                        if status == "success"{
                
                         self.couponLabel.text = String(format: "%@ %@", msg, "%")
                         self.webRequestserviceSummaryDetail(service_order_id: self.service_order_id)
                         self.webRequestProceedforPayment()
                         self.updateValues()
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
    
    func cancelCoupon ()
    {
        let parameters = ["user_master_id": GlobalVariables.shared.user_master_id, "service_order_id": service_order_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "remove_coupon_from_order", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                      //  let msg = json["msg"].stringValue
                        let msg_en = json["msg_en"].stringValue
                        let msg_ta = json["msg"].stringValue
                        let status = json["status"].stringValue
                        let order_id = json["order_id"].stringValue
                        print(order_id)
                        if status == "success"{
                           self.couponLabel.text = "Coupon Applied"
                           self.couponTextField.text = ""
                           self.webRequestserviceSummaryDetail(service_order_id: self.service_order_id)
                           self.webRequestProceedforPayment()
                           self.updateValues()
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
                        let msg_en = json["msg_en"].stringValue
                        let msg_ta = json["msg_ta"].stringValue
                        let status = json["status"].stringValue
                        let order_id = json["order_id"].stringValue
                        print(order_id)
                        if msg == "Service found" && status == "success"{
                            
                            if json["service_list"].count > 0 {
                                let service_Summary = ServiceSummary(json: json["service_list"])
                                UserDefaults.standard.saveServiceSummary(serviceSummary: service_Summary)
                                self.updateValues()
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
    
    func webRequestProceedforPayment ()
    {
        let parameters = ["user_master_id": GlobalVariables.shared.user_master_id,"service_order_id": service_order_id]
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
                        let msg_en = json["msg_en"].stringValue
                        let msg_ta = json["msg_ta"].stringValue
                        let status = json["status"].stringValue
                        if msg == "Proceed for Payment" && status == "success"
                        {
                            GlobalVariables.shared.order_id = json["payment_details"]["order_id"].stringValue
                            GlobalVariables.shared.payableAmount = json["payment_details"]["payable_amount"].stringValue
                            self.updateValues()
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
    
    func serviceStatusCheck (user_master_id: String, service_order_id: String)
    {
        let parameters = ["user_master_id": user_master_id,"service_order_id":service_order_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "service_order_status", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let msg_en = json["msg_en"].stringValue
                        let msg_ta = json["msg_ta"].stringValue
                        let status = json["status"].stringValue
                        if msg == "Service status" && status == "success"{
                            
                            self.orderStatus = json["order_status"].stringValue
//                            self.updateValues()
                            if self.orderStatus == "Paid"
                            {
                                self.paidOutlet.isHidden = true
                                self.showRow = 3
                            }
                            else if self.orderStatus == "Completed"
                            {
                                self.paidOutlet.isHidden = false
                                self.showRow = 3
                            }
                            else
                            {
                                self.showRow = 1
                            }
                            
                            self.tableView.reloadData()
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
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "additionalService"){
            let vc = segue.destination as! AdditionalService
            vc.serviceorderid = self.service_order_id
        }
        else if (segue.identifier == "paymentMethod")
        {
            let vc = segue.destination as! CashMethod
            vc.order_id = GlobalVariables.shared.order_id
            vc.payable_amount = GlobalVariables.shared.payableAmount
        }
        else if (segue.identifier == "bill")
        {
            let vc = segue.destination as! ViewBill
            vc.serviceOrderId = self.service_order_id
        }
    }
    

}
