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
    @IBOutlet weak var termsndConditionLabel: UILabel!
    @IBOutlet weak var checkImg: UIImageView!
    @IBOutlet weak var checkboxOutlet: UIButton!
    
    var cartListArr = [CartList]()
    var cartListServiceName = [String]()
    var text = String()
    var checkboxButtonIsClicked = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addBackButton()
        self.webRequestViewCart()
        self.preferedLanguage()
        self.touchableLabel()
        checkboxButtonIsClicked = true
        self.disableProceedButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.preferedLanguage()

    }
    
    override func viewWillLayoutSubviews() {
        
        proceedOutlet.addShadowToButton(color: UIColor.gray, cornerRadius: 20, backgroundcolor: UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0))
    }
    
    func touchableLabel()
    {
        if LocalizationSystem.sharedInstance.getLanguage() == "en"
        {
            text = "I agree to the Terms and Conditions of SkilEx services."
            termsndConditionLabel.text = text
            self.termsndConditionLabel.textColor =  UIColor.black
            let underlineAttriString = NSMutableAttributedString(string: text)
            let range1 = (text as NSString).range(of: "Terms and Conditions")
                    //underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
                    underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.init(name: "Helvetica-Bold", size: 10.0)!, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red:19.0/255.0 , green: 90.0/255.0, blue: 160/255.0, alpha: 1.0), range: range1)
            termsndConditionLabel.attributedText = underlineAttriString
            termsndConditionLabel.isUserInteractionEnabled = true
            termsndConditionLabel.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        }
        else
        {
            text = "ஸ்கிலெக்ஸ் சேவைகளின் விதிமுறைகளையும் மற்றும் நிபந்தனைகளையும் நான் ஒப்புக்கொள்கிறேன்."
            termsndConditionLabel.text = text
            self.termsndConditionLabel.textColor =  UIColor.black
            let underlineAttriString = NSMutableAttributedString(string: text)
            let range1 = (text as NSString).range(of: "விதிமுறைகளையும் மற்றும் நிபந்தனைகளையும்")
                    //underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
                    underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.init(name: "Helvetica-Bold", size: 10.0)!, range: range1)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red:19.0/255.0 , green: 90.0/255.0, blue: 160/255.0, alpha: 1.0), range: range1)
            termsndConditionLabel.attributedText = underlineAttriString
            termsndConditionLabel.isUserInteractionEnabled = true
            termsndConditionLabel.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        }

    }
    
    func checkbokClicked ()
    {
        if checkboxButtonIsClicked == true
        {
            checkboxButtonIsClicked = false
            self.checkImg.image = UIImage(named: "checkbox_select")
            self.enableProceedButton()
        }
        else
        {
            checkboxButtonIsClicked = true
            self.checkImg.image = UIImage(named: "checkbox_unselect")
            self.disableProceedButton()
        }
    }
    
    func enableProceedButton()
    {
       proceedOutlet.isEnabled = true;
       proceedOutlet.alpha = 1.0;
    }
    
    func disableProceedButton()
    {
        proceedOutlet.isEnabled = false;
        proceedOutlet.alpha = 0.5;
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer)
    {
       let termsRangeEn = (text as NSString).range(of: "Terms and Conditions")
       let termsRangeTa = (text as NSString).range(of: "விதிமுறைகளையும் மற்றும் நிபந்தனைகளையும்")
       // comment for now
       //let privacyRange = (text as NSString).range(of: "Privacy Policy")

       if gesture.didTapAttributedTextInLabel(label: termsndConditionLabel, inRange: termsRangeEn) {
           print("Terms and Conditions")
           self.performSegue(withIdentifier: "termsAndCondition", sender: self)
       }
       else if gesture.didTapAttributedTextInLabel(label: termsndConditionLabel, inRange: termsRangeTa)
       {
           self.performSegue(withIdentifier: "termsAndCondition", sender: self)
       }
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
                        let msg_en = json["msg_en"].stringValue
                        let msg_ta = json["msg_ta"].stringValue
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
                            if LocalizationSystem.sharedInstance.getLanguage() == "en"
                            {
                                self.webRequestViewCart()
                                Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_en) { (action) in
                                    //Custom action code
                                }
                            }
                            else
                            {
                                self.webRequestViewCart()
                                Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_ta) { (action) in
                                    //Custom action code
                                    
                                }
                            }
                            self.advanceAmount.isHidden = true
                            self.advanceAmountLabel.isHidden = true
                            self.totalServiceAmount.isHidden = true
                            self.totalAmountLabel.isHidden = true
                            self.proceedOutlet.isHidden = true
                            self.orderSummaryLabel.isHidden = true
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
                        let msg_en = json["msg_en"].stringValue
                        let msg_ta = json["msg_ta"].stringValue
                        let status = json["status"].stringValue
                        if msg == "Service removed from cart" && status == "success"{
                            if LocalizationSystem.sharedInstance.getLanguage() == "en"
                            {
                                Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_en) { (action) in
                                    //Custom action code
                                    self.webRequestViewCart()
                                }
                            }
                            else
                            {
                                Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_ta) { (action) in
                                    //Custom action code
                                    self.webRequestViewCart()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartListArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServiceDetailTableViewCell
        let cartList = cartListArr[indexPath.row]
        if LocalizationSystem.sharedInstance.getLanguage() == "en"
        {
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
    
    @objc public override func backButtonClick()
    {
        
        let alertController = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicespageBack_text", comment: ""), preferredStyle: UIAlertController.Style.alert)
                           
                   
       let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
           UIAlertAction in

           self.serviceRemoveFromCart(user_master_id: GlobalVariables.shared.user_master_id)

       }
       let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
           UIAlertAction in
       }
       
       alertController.addAction(okAction)
       alertController.addAction(cancelAction)
       self.present(alertController, animated: true, completion: nil)
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
    
    @IBAction func checkboxAction(_ sender: Any)
    {
        self.checkbokClicked()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "customerAddress"){
            let _ = segue.destination as! CustomerAddress
        }
        else if (segue.identifier == "termsAndCondition"){
            let _ = segue.destination as! TermsandCondition
        }
    }
}

extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                              //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}
