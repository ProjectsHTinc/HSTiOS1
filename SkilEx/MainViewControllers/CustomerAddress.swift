//
//  CustomerAddress.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 15/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import MBProgressHUD
import SwiftyJSON

class CustomerAddress: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var proceedOutlet: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    var points: [MKPointAnnotation] = []
    var lat_ = String()
    var long_ = String()
    var time_range = [String]()
    var timeslot_id = [String]()
    var timeslotID = String()
    var location = String()
    var advancepaymentStatus = String()

    var locationManager = CLLocationManager()
    let datePicker = UIDatePicker()
    let picker = UIPickerView()
    
    var timer: Timer?
    var displayMinute = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {
            DispatchQueue.main.async {
                self.locationManager.startUpdatingLocation()
            }
        }
        self.addBackButton()
        address.delegate = self
        name.delegate = self
        phoneNumber.delegate = self
        dateTextField.delegate = self
        timeTextField.delegate = self
        self.address.tag = 1
        self.name.tag = 2
        self.phoneNumber.tag = 3
        self.dateTextField.tag = 4
        self.timeTextField.tag = 5
        self.addToolBar(textField: phoneNumber)
        view.bindToKeyboard()
        self.hideKeyboardWhenTappedAround()
        self.setMapview()
        self.showDatePicker()
        self.showPickerView()
        let userdata = UserDefaults.standard.getUserData()
        let mobNumber = userdata?.phoneNumber
        if mobNumber?.isEmpty == true
        {
            self.phoneNumber.text = ""
        }
        else
        {
            self.phoneNumber.text = mobNumber
        }
        
        self.displayMinute = "1"
        self.preferedLanguage()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.preferedLanguage()
    }
    
    func preferedLanguage()
    {
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "customeraddressnavtitle_text", comment: "")
        self.locationLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "locationaddress_text", comment: "")
        self.nameLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "customeraddressname_text", comment: "")
        self.phoneNumberLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "customeraddressphonenumber_text", comment: "")
        self.dateTextField.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "customeraddressdate_text", comment: "")
        self.timeTextField.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "customeraddresstime_text", comment: "")
        proceedOutlet.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "customeraddressproceed_text", comment: ""), for: .normal)
    }
    
    @objc public override func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == timeTextField
        {
            if self.dateTextField.text?.isEmpty == true
            {
                self.timeTextField.isEnabled = false
                Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: "You have to choose your Date") { (action) in
                    
                self.timeTextField.resignFirstResponder()
                }
            }
            else
            {
                timeTextField.becomeFirstResponder()
            }
        }
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        let now = Date();
        datePicker.minimumDate = now
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.tintColor = UIColor.black
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "done", comment: ""), style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "cancel", comment: ""), style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
    }
    
    @objc func donedatePicker()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        self.dateTextField.resignFirstResponder()
        self.timeTextField.isEnabled = true
        self.timeSlot(user_master_id: GlobalVariables.shared.user_master_id, service_date: self.dateTextField.text!)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func showPickerView(){
        
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        toolbar.tintColor = UIColor.black
        let doneButton = UIBarButtonItem(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "done", comment: ""), style: .plain, target: self, action: #selector(donePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "cancel", comment: ""), style: .plain, target: self, action: #selector(cancelPicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        timeTextField.inputAccessoryView = toolbar
        timeTextField.inputView = picker
    }
    
    @objc func donePicker(){
        let row = picker.selectedRow(inComponent: 0)
        self.picker.selectRow(row, inComponent: 0, animated: false)
        self.timeTextField.text = time_range[row]
        timeslotID = timeslot_id[row]
        print(timeslotID)
        self.timeTextField.resignFirstResponder()
    }
    
    @objc func cancelPicker(){
        self.view.endEditing(true)
    }
    
    //MARK:- UIPickerViewDataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return time_range.count
    }
    
    //MARK:- UIPickerViewDelegates methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return time_range[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.timeTextField.text = time_range[row]
    }
    
    func setMapview(){
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0.1
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.mapView.addGestureRecognizer(lpgr)
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            let touchLocation = gestureReconizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation,toCoordinateFrom: mapView)
            removeAnnotation(location: locationCoordinate)
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            return
        }
        if gestureReconizer.state != UIGestureRecognizer.State.began {
            let touchLocation = gestureReconizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation,toCoordinateFrom: mapView)
            addAnnotation(location: locationCoordinate)
            lat_ = String(format:"%f", locationCoordinate.latitude)
            long_ = String(format:"%f", locationCoordinate.longitude)
            self.getAddressFromLatLon(pdblLatitude: lat_, withLongitude: long_)
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            }
            return
        }
    
    func addAnnotation(location: CLLocationCoordinate2D)
    {
        GlobalVariables.shared.reuseID = "pin"
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = ""
        annotation.subtitle = ""
        self.mapView.addAnnotation(annotation)
    }
    
    func removeAnnotation(location: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = ""
        annotation.subtitle = ""
        self.mapView.removeAnnotations(self.mapView.annotations)
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country as Any)
                    print(pm.locality as Any)
                    print(pm.subLocality as Any)
                    print(pm.thoroughfare as Any)
                    print(pm.postalCode as Any)
                    print(pm.subThoroughfare as Any)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                        self.location = addressString
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                        print(addressString)
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                        print(addressString)
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                        print(addressString)
                    }
                     MBProgressHUD.hide(for: self.view, animated: true)
                     self.address.text = addressString
                }
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        locationManager.stopUpdatingLocation()
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.0275, longitudeDelta: 0.0275)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        proceedOutlet.addShadowToButton(color: UIColor.gray, cornerRadius: 16, backgroundcolor: UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {   
        let nextTag = textField.tag + 1
        // Try to find next responder
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder?
        
        if nextResponder != nil {
            // Found next responder, so set it
            nextResponder?.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == phoneNumber
        {
            let maxLength = 10
            let currentString: NSString = phoneNumber.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
           return true
    }
    
    func timeSlot (user_master_id: String, service_date: String)
    {
        let parameters = ["user_master_id": user_master_id, "service_date": service_date]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "view_time_slot", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let msg_ta = json["msg_ta"].stringValue
                        let status = json["status"].stringValue
                        if msg == "View Timeslot" && status == "success"{
                            
                            if json["service_time_slot"].count > 0 {
                                
                                self.time_range = []
                                self.timeslot_id = []
                                
                                for i in 0..<json["service_time_slot"].count {
                                    
                                    let service_time_slot = TimeSlot.init(json: json["service_time_slot"][i])
                                    self.time_range.append(service_time_slot.time_range!)
                                    self.timeslot_id.append(service_time_slot.timeslot_id!)
                                }
                                
                                    self.picker.reloadAllComponents()
                            }
                            else
                            {
                                Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_ta) { (action) in
                                    // Custom action code
                                    
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
    
    @IBAction func proceedAction(_ sender: Any)
    {
        
        if address.text == ""
        {
            Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "addressfield", comment: "")) { (action) in
            }
        }
        else if name.text == ""
        {
            Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "namefield", comment: "")) { (action) in 
            }
        }
        else if phoneNumber.text == ""
        {
            Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "mobilefield", comment: "")) { (action) in
            }
        }
        else if phoneNumber.text?.count != 10
        {
            Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "mobilefield", comment: "")) { (action) in
            }
        }
        else if dateTextField.text == ""
        {
            Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "datefield", comment: "")) { (action) in
            }
        }
        else if timeTextField.text == ""
        {
            Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "timefield", comment: "")) { (action) in
            }
        }
        else
        {
            let date = Date()
            self.webRequest(user_master_id: GlobalVariables.shared.user_master_id,contact_person_name: self.name.text!,contact_person_number: self.phoneNumber.text!, service_latlon: String(format: "%@%@%@", lat_,",",long_), service_location: self.location, service_address: self.address.text!, order_date: date.formattedDateFromString(dateString: self.dateTextField.text!, withFormat:"yyyy-MM-dd")!, order_timeslot_id: timeslotID)
        }
    }
    
    func webRequest(user_master_id: String, contact_person_name: String, contact_person_number: String, service_latlon: String, service_location: String, service_address: String, order_date: String, order_timeslot_id: String)
    {
        let parameters = ["user_master_id": user_master_id, "contact_person_name": contact_person_name, "contact_person_number": contact_person_number, "service_latlon": service_latlon, "service_location": service_location, "service_address": service_address, "order_date": order_date, "order_timeslot_id": order_timeslot_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "proceed_to_book_order", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let status = json["status"].stringValue
                        if msg == "Service done" && status == "success"{

                            if json["service_details"].count > 0
                            {
                                let advance_amount = json["service_details"]["advance_amount"].stringValue
                                GlobalVariables.shared.Advanceamount = advance_amount
                                GlobalVariables.shared.order_id = json["service_details"]["order_id"].stringValue
                                self.advancepaymentStatus = json["service_details"]["advance_payment_status"].stringValue
                                if  self.advancepaymentStatus == "NA"
                                {
                                    UserDefaults.standard.set("CA", forKey: "Advance/customer")
                                    self.serviceProviderAllocation(user_master_id: GlobalVariables.shared.user_master_id, order_id: GlobalVariables.shared.order_id, displayMinute: self.displayMinute)
                                }
                                else
                                {
                                    self.performSegue(withIdentifier: "advancePayment", sender: self)
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
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(callServiceAllocation), userInfo: nil, repeats: true);
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func callServiceAllocation()
    {
        self.serviceProviderAllocation(user_master_id: GlobalVariables.shared.user_master_id, order_id: GlobalVariables.shared.order_id, displayMinute: self.displayMinute)
    }
    
    func serviceProviderAllocation(user_master_id: String, order_id: String, displayMinute: String)
    {
        let parameters = ["user_master_id": user_master_id, "order_id": order_id, "display_minute": displayMinute]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "service_provider_allocation", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let msg_en = json["msg_en"].stringValue
                        let msg_ta = json["msg_ta"].stringValue
                        let status = json["status"].stringValue
                        if msg == "Mobile OTP" && status == "success"
                        {
                           self.stopTimer()
                            if LocalizationSystem.sharedInstance.getLanguage() == "en"
                            {
                                Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_en) { (action) in
                                    //Custom action code
                                    self.performSegue(withIdentifier: "bookingSuccess", sender: self)
                                }
                            }
                            else
                            {
                                Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_ta) { (action) in
                                    //Custom action code
                                    self.performSegue(withIdentifier: "bookingSuccess", sender: self)
                                }
                            }
                        }
                        else
                        {

                            if self.displayMinute == "1"
                            {
                                self.startTimer()
                                self.displayMinute = "2"
                            }
                            else if self.displayMinute == "2"
                            {
                                
                                self.displayMinute = "3"
                            }
                            else
                            {
                                self.stopTimer()
                            }
                            
                            self.performSegue(withIdentifier: "bookingSuccess", sender: self)

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
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "advancePayment"){
            let vc = segue.destination as! AdvancePayment
            vc.advance_amount = GlobalVariables.shared.Advanceamount
            vc.orderId = GlobalVariables.shared.order_id
        }
        else if (segue.identifier == "bookingSuccess")
        {
            let _ = segue.destination as! BookingSuccess
        }
    }
    

}
