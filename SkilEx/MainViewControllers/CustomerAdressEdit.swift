//
//  CustomerAdressEdit.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 04/12/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import MBProgressHUD
import SwiftyJSON
import Alamofire

class CustomerAdressEdit: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate  {
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var streetName: UITextField!
    @IBOutlet weak var addresslbl: UILabel!
    @IBOutlet weak var streetNamelbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var saveAdresss: UIButton!
    
    var AddressArr = [String]()
    var locationManager = CLLocationManager()
    var points: [MKPointAnnotation] = []
    var lat_ = String()
    var long_ = String()
    var lat1_ = String()
    var long1_ = String()
    var location = String()
    var fromDidupDateLocation = Bool()
    var fromTappingMapView = Bool()
    
    var timer: Timer?
    var displayMinute = String()
    var task: URLSessionTask? = nil
    var startLocation = CLLocation()
    var lastLocation = CLLocation()
    let geoCoder = CLGeocoder()
    var availableDistance = false
    
    var contact_Name = String()
    var Phone_Number = String()
    var seviceId = String()
    var serviceLocation = String()
    var seviceAdress = String()
    var seviceLatLong = String()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setMapview()
        self.addBackButton()
        print(seviceLatLong)
        print(contact_Name)
        location = serviceLocation
        self.hideKeyboardWhenTappedAround()
       
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy =  kCLLocationAccuracyBestForNavigation
        //locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {
            DispatchQueue.main.async {
                self.locationManager.startUpdatingLocation()
            }
        }
        address.delegate = self
        name.delegate = self
        phoneNumber.delegate = self
        streetName.delegate = self
       
        self.address.tag = 1
        self.name.tag = 2
        self.phoneNumber.tag = 3
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
        self.getGPAddress(givenAddress: "Gandhipuram Town Bus Stand Coimbatore")
        fromTappingMapView = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        address.text = serviceLocation
        phoneNumber.text = Phone_Number
        name.text = contact_Name
        streetName.text = seviceAdress
        seviceLatLong =  (String(format: "%@%@%@", lat1_,",",long1_) as NSString) as String
        print(seviceLatLong)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.preferedLanguage()
        
        AlertController.shared.showAlert(targetVC: self, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "customeraddressfirstalert", comment: ""), complition: {
        })
        
        address.text = serviceLocation
        phoneNumber.text = Phone_Number
        name.text = contact_Name
        streetName.text = seviceAdress
        seviceLatLong =  (String(format: "%@%@%@", lat1_,",",long1_) as NSString) as String
        print(seviceLatLong)
    }
    
    @objc public override func backButtonClick()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func preferedLanguage()
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "customeraddressnavtitle_text", comment: "")
        self.streetNamelbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "locationaddress_text", comment: "")
        self.addresslbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "locationaddressStreetName_text", comment: "")
        self.nameLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "customeraddressname_text", comment: "")
        self.phoneNumberLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "customeraddressphonenumber_text", comment: "")
        saveAdresss.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "save_Address", comment: ""), for: .normal)
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func setMapview()
    {
      
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0.1
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.mapView.addGestureRecognizer(lpgr)
        
    }
     
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer)
    {
        if gestureReconizer.state != UIGestureRecognizer.State.ended
        {
            let touchLocation = gestureReconizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation,toCoordinateFrom: mapView)
            removeAnnotation(location: locationCoordinate)
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            return
        }
        
        if gestureReconizer.state != UIGestureRecognizer.State.began
        {
            let touchLocation = gestureReconizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation,toCoordinateFrom: mapView)
            addAnnotation(location: locationCoordinate)
            lat_ = String(format:"%f", locationCoordinate.latitude)
            long_ = String(format:"%f", locationCoordinate.longitude)
            fromDidupDateLocation = false
            fromTappingMapView = true
            self.getAddressFromLatLon(pdblLatitude: lat_, withLongitude: long_)
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
        }
            return
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String)
    {
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
                    print(pm.administrativeArea as Any)
                    print(pm.subAdministrativeArea as Any)
                    print(pm.subThoroughfare as Any)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                        self.location = addressString
                        
                        self.streetName.text = addressString
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
                    if (self.fromDidupDateLocation == true)
                    {
                        self.streetName.text = self.seviceAdress
                    }
                    else
                    {
                        if pm.thoroughfare != nil {
                           
                            self.streetName.text = pm.thoroughfare! + ", "
                        }
                      
                        self.address.text = addressString
                        self.ConvertAddressToLatLon(givenAddress: self.address.text!)
                    }
                    
                }
        })
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
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        locationManager.stopUpdatingLocation()
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.0275, longitudeDelta: 0.0275)
        let region = MKCoordinateRegion(center: locValue, span: span)
        
        lat_ = String(manager.location!.coordinate.latitude)
        long_ = String(manager.location!.coordinate.longitude)
        fromDidupDateLocation = true
        self.getAddressFromLatLon(pdblLatitude: lat_, withLongitude: long_)
        mapView.setRegion(region, animated: true)
    }
    
    func ConvertAddressToLatLon(givenAddress:String)
    {
        geoCoder.geocodeAddressString(givenAddress) {
            placemarks, error in
            let placemark = placemarks?.last
            let startLatitude = placemark?.location?.coordinate.latitude
            let endLongitude = placemark?.location?.coordinate.longitude
            if startLatitude != nil && endLongitude != nil{
                self.lastLocation = CLLocation(latitude:  startLatitude!, longitude:  endLongitude!)
            }
            else
            {
                AlertController.shared.showAlert(targetVC: self, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: "Invalid Address", complition: {

                })
            }
            print(placemark?.location?.coordinate.latitude as Any,placemark?.location?.coordinate.longitude as Any)
            self.calculateDistance(startLocation: self.startLocation, EndLocation: self.lastLocation)
//          print("Lat: \(startLatitude), Lon: \(EndLongitude)")
        }
    }
        
    func getGPAddress(givenAddress:String)
    {
        geoCoder.geocodeAddressString(givenAddress) {
            placemarks, error in
            let placemark = placemarks?.first
            self.startLocation = CLLocation(latitude:  11.016683, longitude:  76.969040)
            print(placemark?.location?.coordinate.latitude as Any,placemark?.location?.coordinate.longitude as Any)
          
        }
    }
    
    func calculateDistance (startLocation: CLLocation, EndLocation:CLLocation){
        let distanceMeters: CLLocationDistance  = (startLocation.distance(from: EndLocation))
        let distance =  Int(distanceMeters / 1000.0)
        if distance <= 20{
            availableDistance = true
        }
        else{
            availableDistance = false
        }
    }
    
    
    @IBAction func saveAddressAction(_ sender: Any) {
        
        if address.text == ""
        {
            AlertController.shared.showAlert(targetVC: self, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "addressfield", comment: ""), complition: {

            })
        }
        else if name.text == ""
        {
            AlertController.shared.showAlert(targetVC: self, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "namefield", comment: ""), complition: {

            })
        }
        else if phoneNumber.text == ""
        {
            AlertController.shared.showAlert(targetVC: self, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "mobilefield", comment: ""), complition: {

            })
        }
        else if phoneNumber.text?.count != 10
        {
            AlertController.shared.showAlert(targetVC: self, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "mobilefield", comment: ""), complition: {

            })
        }
        
        else if availableDistance == false {
            AlertController.shared.showAlert(targetVC: self, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: "We don't provide this service in your area currently", complition: {

            })
        }

        else
        {
            self.webRequest(contact_name: self.name.text!,contact_no: self.phoneNumber.text!, serv_lat_lon: String(format: "%@%@%@", lat_,",",long_), serv_loc: self.streetName.text!, serv_address:self.address.text!,seviceid:seviceId)
            print (String(format: "%@%@%@", lat_,",",long_))
        }
    }
    
    func webRequest(contact_name: String, contact_no: String, serv_lat_lon: String, serv_loc: String, serv_address: String,seviceid:String)
    {
        let parameters = [ "contact_name": contact_name, "contact_no": contact_no, "serv_lat_lon": serv_lat_lon, "serv_loc": serv_loc, "serv_address": serv_address,"address_id":seviceid]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "customer_address_edit", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg_en"].stringValue
                        let status = json["status"].stringValue
                        if msg == "Address Updated successfully" && status == "success" {
                            
                            Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "address_update_Alert", comment: ""), message: "") { (action) in
                                
                                self.navigationController?.popViewController(animated: true)
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
