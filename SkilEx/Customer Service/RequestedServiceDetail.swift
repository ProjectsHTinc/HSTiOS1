//
//  RequestedServiceDetail.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 25/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class RequestedServiceDetail: UIViewController {
    
    var service_order_id  = String()
    var advancePayment_Status = String()
    
    @IBOutlet weak var mainCategoeryName: UILabel!
    @IBOutlet weak var subCategoeryName: UILabel!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var customerNumberLabel: UILabel!
    @IBOutlet weak var customerNumber: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var estimatedCostLabel: UILabel!
    @IBOutlet weak var estimatedCost: UILabel!
    @IBOutlet weak var cancelServiceOutLet: UIButton!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var orderidLabel: UILabel!
    
    let serviceListDetail = UserDefaults.standard.getServicesDetail()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addBackButton()
        self.LoadValues()
        self.subView.dropShadow(offsetX: 0, offsetY: 1, color: UIColor.gray, opacity: 0.5, radius: 6)
        print(advancePayment_Status)
        self.preferedLanguage()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.preferedLanguage()
    }
    
    override func viewWillLayoutSubviews() {
        cancelServiceOutLet.addShadowToButton(color: UIColor.clear, cornerRadius: 20, backgroundcolor: UIColor.clear)
    }
    
    func preferedLanguage()
    {
        self.navigationItem.title =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesdetailrequestednavtitle_text", comment: "")
        self.customerNameLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesdetailrequestedcustomername_text", comment: "")
        self.customerNumberLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesdetailrequestedcustomernumber_text", comment: "")
        self.estimatedCostLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesdetailrequestedestimated_text", comment: "")
        self.addressLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesdetailrequestedaddress_text", comment: "")
        self.cancelServiceOutLet.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesdetailrequestedcancel_text", comment: ""), for: .normal)
        
    }
    
    func LoadValues()
    {
        if LocalizationSystem.sharedInstance.getLanguage() == "en"
        {
            self.mainCategoeryName.text = serviceListDetail?.main_category
           // self.subCategoeryName.text = serviceListDetail?.sub_category
            self.serviceName.text = serviceListDetail?.service_name
            self.date.text = serviceListDetail?.order_date
            self.time.text = serviceListDetail?.time_slot
            self.customerName.text = serviceListDetail?.contact_person_name
            self.customerNumber.text = serviceListDetail?.contact_person_number
            self.estimatedCost.text = serviceListDetail?.estimated_cost
            self.address.text = serviceListDetail?.service_address
            self.orderidLabel.text = String(format: "%@ : %@",LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesorderID_text", comment: ""),serviceListDetail!.service_order_id ?? "")
        }
        else
        {
            self.mainCategoeryName.text = serviceListDetail?.main_category_ta
          //  self.subCategoeryName.text = serviceListDetail?.sub_category_ta
            self.serviceName.text = serviceListDetail?.service_name
            self.date.text = serviceListDetail?.order_date
            self.time.text = serviceListDetail?.time_slot
            self.customerNameLabel.text = serviceListDetail?.contact_person_name
            self.customerNumber.text = serviceListDetail?.contact_person_number
            self.estimatedCost.text = serviceListDetail?.estimated_cost
            self.address.text = serviceListDetail?.service_address
            self.orderidLabel.text = String(format: "%@ : %@",LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesorderID_text", comment: ""),serviceListDetail!.service_order_id ?? "")

        }
    }
    
    @objc public override func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "cancelService", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "requestedService"){
            let _ = segue.destination as! RequestedService
        }
        else if (segue.identifier == "cancelService")
        {
            let vc = segue.destination as! CancelService
            vc.serviceId = self.service_order_id
            vc.advancePayment_Status = advancePayment_Status
        }
    }

}
