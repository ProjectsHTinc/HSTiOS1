//
//  CancelService.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 29/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class CancelService: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var resonTextField: DesignableUITextField!
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var submitOutlet: UIButton!
    @IBOutlet weak var commentslabel: UILabel!
    
    let picker = UIPickerView()
    var cancelReason = [String]()
    var id = [String]()
    var resonId = String()
    var serviceId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addBackButton()
        self.preferedLanguage()
        self.webRequestCancelReson()
        self.resonTextField.delegate = self
        self.commentsTextView.delegate = self
        self.showPickerView()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillLayoutSubviews() {
        submitOutlet.addShadowToButton(color: UIColor.gray, cornerRadius: 18, backgroundcolor: UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0))
    }
    
    func preferedLanguage () {
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "cancelservicenavtitle_text", comment: "")
        self.resonTextField.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "cancelservicetextfield_text", comment: "")
        self.commentslabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "cancelservicecommnets_text", comment: "")
        self.submitOutlet.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "cancelservicesubmit_text", comment: ""), for: .normal)
    }
    
    @objc public override func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
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
        resonTextField.inputAccessoryView = toolbar
        resonTextField.inputView = picker
    }
    
    @objc func donePicker(){
        let row = picker.selectedRow(inComponent: 0)
        self.picker.selectRow(row, inComponent: 0, animated: false)
        self.resonTextField.text = cancelReason[row]
        resonId = id[row]
        print(resonId)
        self.resonTextField.resignFirstResponder()
    }
    
    @objc func cancelPicker(){
        self.view.endEditing(true)
    }
    
    //MARK:- UIPickerViewDataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cancelReason.count
    }
    
    //MARK:- UIPickerViewDelegates methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cancelReason[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.resonTextField.text = cancelReason[row]
    }
    
    func webRequestCancelReson ()
    {
        let parameters = ["user_master_id": GlobalVariables.shared.user_master_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "list_reason_for_cancel", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let status = json["status"].stringValue
                        if msg == "Service Cancelled" && status == "success"{
                          
                            if json["reason_list"].count > 0 {
                                
                                self.cancelReason = []
                                self.id = []
                                
                                for i in 0..<json["reason_list"].count {
                                    
                                    let cancel_Reson = CancelReson.init(json: json["reason_list"][i])
                                    self.cancelReason.append(cancel_Reson.cancel_reason!)
                                    self.id.append(cancel_Reson.id!)
                                }
                                
                                 print(self.cancelReason)
                                 self.picker.reloadAllComponents()
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
    
    @IBAction func submitAction(_ sender: Any)
    {
        if resonTextField.text?.isEmpty == true
        {
            Alert.defaultManager.showOkAlert("SkilEx", message: "Reson Cannot be empty") { (action) in
            }
        }
        else if commentsTextView.text.isEmpty == true
        {
            Alert.defaultManager.showOkAlert("SkilEx", message: "Comments Cannot be empty") { (action) in
            }
        }
        else
        {
            self.webRequestCancelService(user_master_id: GlobalVariables.shared.user_master_id, service_order_id: serviceId, cancel_id: resonId, comments: self.commentsTextView.text)
        }
    }
    
    func webRequestCancelService(user_master_id: String, service_order_id: String, cancel_id:String, comments:String){
    
            let parameters = ["user_master_id": user_master_id, "service_order_id": service_order_id]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            DispatchQueue.global().async
                {
                    do
                    {
                        try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "cancel_service_order", params: parameters, headers: nil, success: {
                            (JSONResponse) -> Void in
                            MBProgressHUD.hide(for: self.view, animated: true)
                            print(JSONResponse)
                            let json = JSON(JSONResponse)
                            let msg = json["msg"].stringValue
                            let status = json["status"].stringValue
                            if msg == "Service Cancelled successfully" && status == "success"{
    
                                Alert.defaultManager.showOkAlert("SkilEx", message: msg) { (action) in
                                    //Custom action code
                                  self.performSegue(withIdentifier: "requestedService", sender: self)
                                }
    
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    /* Older versions of Swift */
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "requestedService")
        {
            let _ = segue.destination as! RequestedService
        }
        
    }
    

}
