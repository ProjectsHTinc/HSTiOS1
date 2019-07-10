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


class ServiceDetail: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource {
   
    var scrollView: UIScrollView?
    var segmentedControl4: HMSegmentedControl?
    var main_cat_id = String()
    var subcategoeryNameArr = [String]()
    var subcategoeryIDArr = [String]()
    var serviceArr = [Services]()
    var service_nameArr = [String]()
    var cellButtonisSelected = false
    var serviceID = String()
    var serviceImage = UIImage()
    
    var exclusions_ta = String()
    var is_advance_payment = String()
    var service_ta_name = String()
    var rate_card_details_ta = String()
    var advance_amount = String()
    var service_procedure = String()
    var inclusions = String()
    var service_name = String()
    var sub_cat_id = String()
    var others = String()
    var exclusions = String()
    var service_procedure_ta = String()
    var rate_card = String()
    var service_id = String()
    var others_ta = String()
    var inclusions_ta = String()
    var rate_card_details = String()

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let viewWidth = view.frame.width
        let segmentedControl1 = HMSegmentedControl(sectionTitles: subcategoeryNameArr)
        segmentedControl1!.autoresizingMask = [.flexibleRightMargin, .flexibleWidth]
        segmentedControl1?.frame = CGRect(x: 0, y: 0, width: viewWidth, height: 50)
        segmentedControl1?.segmentEdgeInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        segmentedControl1?.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
        segmentedControl1?.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        segmentedControl1?.backgroundColor = UIColor.white
        segmentedControl1?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        let font = UIFont.systemFont(ofSize: 14)
        segmentedControl1?.titleTextAttributes = [NSAttributedString.Key.font: font]
        segmentedControl1?.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.0/255, green: 108.0/255, blue: 255.0/255.0, alpha: 1.0)]
        segmentedControl1?.selectionIndicatorColor = UIColor(red: 0.0/255, green: 108.0/255, blue: 255.0/255.0, alpha: 1.0)
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
        
        let index = self.subcategoeryIDArr[0]
        self.webRequestwebRequest(Index: index)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func segmentedControlChangedValue(_ segmentedControl: HMSegmentedControl?) {
        print(String(format: "Selected index %ld (via UIControlEventValueChanged)", Int(segmentedControl?.selectedSegmentIndex ?? 0)))
        
        let index = self.subcategoeryIDArr[Int(segmentedControl?.selectedSegmentIndex ?? 0)]
        self.webRequestwebRequest(Index:index)
    }
    
    func webRequestwebRequest (Index:String)
    {
        let url = AFWrapper.BASE_URL + "services_list"
        let parameters = ["main_cat_id": main_cat_id, "sub_cat_id": Index]
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
                        if msg == "View Services" && status == "success"
                        {
                            if json["services"].count > 0 {
                                
                                for i in 0..<json["services"].count {
                                    
                                    let services = Services.init(json: json["services"][i])
                                    self.serviceArr.append(services)
                                    let service_name = services.service_name
                                    self.service_nameArr.append(service_name!)
                                }
                                
                                self.tableView .reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return serviceArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServiceDetailTableViewCell
        cell.tickImage.isHidden = true
        cell.addImage.isHidden = false
        cell.addLabel.isHidden = false
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
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
        return cell
    }
    
    @objc func buttonSelected(sender: UIButton){
        print(sender.tag)
        cellButtonisSelected = true
        let myIndexPath = NSIndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: myIndexPath as IndexPath) as! ServiceDetailTableViewCell
        cell.selectionBackgroundView.backgroundColor =  UIColor(red: 142.0/255, green: 198.0/255, blue: 65.0/255, alpha: 1.0)
        cell.addImage.isHidden = true
        cell.addLabel.isHidden = true
        cell.tickImage.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let index = serviceArr[indexPath.row]
        serviceID = index.service_id!
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
                                let serviceDetails = ServicesDescripition(json: json)
                                let imgUrl = serviceDetails.service_pic_url
                                self.advance_amount = serviceDetails.advance_amount!
                                self.exclusions = serviceDetails.exclusions!
                                self.exclusions_ta = serviceDetails.exclusions_ta!
                                self.inclusions = serviceDetails.inclusions!
                                self.inclusions_ta = serviceDetails.inclusions_ta!
                                self.is_advance_payment = serviceDetails.is_advance_payment!
                                self.others = serviceDetails.others!
                                self.others_ta = serviceDetails.others_ta!
                                self.rate_card = serviceDetails.rate_card!
                                self.rate_card_details = serviceDetails.rate_card_details!
                                self.rate_card_details_ta = serviceDetails.rate_card_details_ta!
                                self.service_id = serviceDetails.service_id!
                                self.service_name = serviceDetails.service_name!
                                self.service_procedure = serviceDetails.service_procedure!
                                self.service_procedure_ta = serviceDetails.service_procedure_ta!
                                self.service_ta_name = serviceDetails.service_ta_name!
                                self.sub_cat_id = serviceDetails.sub_cat_id!

                                if imgUrl?.isEmpty == false
                                {
                                    let url = URL(string: imgUrl!)
                                    DispatchQueue.global().async { [weak self] in
                                        if let data = try? Data(contentsOf: url!) {
                                            if let image = UIImage(data: data) {
                                                DispatchQueue.main.async {
                                                    self?.serviceImage = image
                                                    self!.performSegue(withIdentifier: "serviceDescrption", sender: self)
                                                }
                                            }
                                        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 93
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "serviceDescrption") {
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! ServiceDescripition
            vc.serviceImage = self.serviceImage
            vc.advance_amount = self.advance_amount
            vc.exclusions = self.exclusions
            vc.exclusions_ta = self.exclusions_ta
            vc.inclusions = self.inclusions
            vc.inclusions_ta = self.inclusions_ta
            vc.is_advance_payment = self.is_advance_payment
            vc.others = self.others
            vc.others_ta = self.others_ta
            vc.rate_card = self.rate_card
            vc.rate_card_details = self.rate_card_details
            vc.rate_card_details_ta = self.rate_card_details_ta
            vc.service_id = self.service_id
            vc.service_name = self.service_name
            vc.service_procedure = self.service_procedure
            vc.service_procedure_ta = self.service_procedure_ta
            vc.service_ta_name = self.service_ta_name
            vc.sub_cat_id = self.sub_cat_id
        }
    }
}
