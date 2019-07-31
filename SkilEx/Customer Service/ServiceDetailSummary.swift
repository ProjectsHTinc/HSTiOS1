//
//  ServiceDetailSummary.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 27/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class ServiceDetailSummary: UITableViewController
{
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
    @IBOutlet weak var shareOutlet: UIButton!
    @IBOutlet weak var viewBillLabel: UILabel!
    
    var order_status = String()
    var service_order_id = String()
    
    let bookingDetailSummary = UserDefaults.standard.getServiceSummary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.addBackButton()
        self.preferedLanguage()
        self.serviceStatusCheck (user_master_id: GlobalVariables.shared.user_master_id, service_order_id: service_order_id)
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
        self.additionalServiceChargeLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicehistorysummaryadditionalservicecharge_text", comment: "")
        self.couponLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicehistorysummarycouponapplied_text", comment: "")
        self.subTotalLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicehistorysummarycouponapplied_text", comment: "")
        self.advanceAmountLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicehistorysummaryadvanceamount_text", comment: "")
        self.grandTotalLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicehistorysummarygrandtotal_text", comment: "")
        self.viewBillLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicehistorysummaryviewbill_text", comment: "")
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
                        let status = json["status"].stringValue
                        if msg == "Service status" && status == "success"{
                            
                            self.order_status = json["order_status"].stringValue
                            self.updateValues()
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
    
    func updateValues ()
    {
        if LocalizationSystem.sharedInstance.getLanguage() == "en"
        {
            self.serviceDate.text = bookingDetailSummary?.order_date
            self.requestedTime.text = bookingDetailSummary?.time_slot
            self.serviceProvider.text = bookingDetailSummary?.provider_name
            self.servicePerson.text = bookingDetailSummary?.person_name
            self.serviceStartDate.text = bookingDetailSummary?.service_start_time
            self.serviceStartTime.text = bookingDetailSummary?.service_start_time
            self.serviceCompletedDate.text = bookingDetailSummary?.service_end_time
            self.additionalServiceTextField.text = String(format: "%@ - %@",  "Additional Service",bookingDetailSummary!.additional_service!)
            self.materialUsedTextView.text = bookingDetailSummary?.material_notes
            self.serviceCharge.text = bookingDetailSummary?.service_amount
            self.additionalServiceCharge.text = bookingDetailSummary?.additional_service_amt
            self.advanceAmount.text = bookingDetailSummary?.paid_advance_amt
            self.coupon.text = bookingDetailSummary?.discount_amt
            let coupon_id = bookingDetailSummary?.coupon_id
            if coupon_id == "0"
            {
                self.grandTotal.text = bookingDetailSummary?.net_service_amount
            }
            else
            {
                self.grandTotal.text = bookingDetailSummary?.payable_amount
            }
            
            if self.order_status == "Cancelled"
            {
                self.serviceCompletedLabel.text = "Service Cancelled On"
            }
            else
            {
                self.serviceCompletedLabel.text = "Service Completed On"

            }
        }
        else
        {
            self.serviceDate.text = bookingDetailSummary?.order_date
            self.requestedTime.text = bookingDetailSummary?.time_slot
            self.serviceProvider.text = bookingDetailSummary?.provider_name
            self.servicePerson.text = bookingDetailSummary?.person_name
            let fullName = bookingDetailSummary?.service_start_time
            let fullNameArr = fullName!.components(separatedBy: " ")
            let date = fullNameArr[0]
            let time = fullNameArr[1]
            self.serviceStartDate.text = date
            self.serviceStartTime.text = time
            self.serviceCompletedDate.text = bookingDetailSummary?.service_end_time
            self.additionalServiceTextField.text = String(format: "%@ - %@",  "Additional Service",bookingDetailSummary!.additional_service!)
            self.materialUsedTextView.text = bookingDetailSummary?.material_notes
            self.serviceCharge.text = bookingDetailSummary?.service_amount
            self.additionalServiceCharge.text = bookingDetailSummary?.additional_service_amt
            self.coupon.text = bookingDetailSummary?.discount_amt
            self.advanceAmount.text = bookingDetailSummary?.paid_advance_amt
            let coupon_id = bookingDetailSummary?.coupon_id
            if coupon_id == "0"
            {
                self.grandTotal.text = bookingDetailSummary?.net_service_amount
            }
            else
            {
                self.grandTotal.text = bookingDetailSummary?.payable_amount
            }
            if self.order_status == "Cancelled"
            {
                self.serviceCompletedLabel.text = "சேவை ரத்து செய்யப்பட்டது"
            }
            else
            {
                self.serviceCompletedLabel.text = "சேவை முடிந்தது"
            }
        }
    }
    
    @objc public override func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    @IBAction func additionalServiceAction(_ sender: Any)
    {
        let additionalService = bookingDetailSummary?.additional_service
        if additionalService == "0"
        {
            Alert.defaultManager.showOkAlert("SkilEx", message: "Additional Service is Empty") { (action) in
            }
        }
        else
        {
            self.performSegue(withIdentifier: "additionalService", sender: self)
        }
    }
    
    @IBAction func viewBillAction(_ sender: Any)
    {
        
    }
    
    @IBAction func shareAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "paymentMethod", sender: self)
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
            let _ = segue.destination as! CashMethod
        }
    }
    

}
