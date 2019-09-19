//
//  Tracking.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 26/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
import MapKit
import CoreLocation

class Tracking: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var mainCatogery: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    var timer: Timer?
    var locationManager = CLLocationManager()
    var latitude = Double()
    var longitude = Double()
    
    let serviceListDetail = UserDefaults.standard.getServicesDetail()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        self.stopTimer()
        self.addBackButton()
        self.subView.dropShadow(offsetX: 0, offsetY: 1, color:  UIColor.gray, opacity: 0.5, radius: 6)
        self.webRequestTracking(user_master_id: GlobalVariables.shared.user_master_id, person_id: (serviceListDetail?.person_id!)!)
        self.preferedLanguage()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.preferedLanguage()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let loc: CLLocation = CLLocation(latitude:self.latitude, longitude: self.longitude)
        let coordinateRegion = MKCoordinateRegion(center: loc.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(coordinateRegion, animated: true)
        let center = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        addAnnotation(location: center)
    }
    
    func addAnnotation(location: CLLocationCoordinate2D){
        GlobalVariables.shared.reuseID = "image"
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = ""
        annotation.subtitle = ""
        self.mapView.addAnnotation(annotation)
    }
    
   
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to initialize GPS: ", error.description)
    }
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(webRequest), userInfo: nil, repeats: true);
        }
    }
    
    @objc func webRequest()
    {
        self.webRequestTracking(user_master_id: GlobalVariables.shared.user_master_id, person_id: (serviceListDetail?.person_id!)!)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func preferedLanguage () {
        
        if LocalizationSystem.sharedInstance.getLanguage() == "en"
        {
            self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "trackingnavtitle_text", comment: "")
            self.personName.text = serviceListDetail?.person_name
            self.mainCatogery.text = serviceListDetail?.main_category
            self.dateLabel.text = serviceListDetail?.order_date
            self.timeLabel.text = serviceListDetail?.time_slot
            
        }
        else
        {
            self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "trackingnavtitle_text", comment: "")
            self.personName.text = serviceListDetail?.person_name
            self.mainCatogery.text = serviceListDetail?.main_category_ta
            self.dateLabel.text = serviceListDetail?.order_date
            self.timeLabel.text = serviceListDetail?.time_slot

        }
    }
    
    @objc public override func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func webRequestTracking (user_master_id: String, person_id: String)
    {
        let parameters = ["user_master_id": user_master_id, "person_id": person_id]
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "service_person_tracking", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let msg_en = json["msg_en"].stringValue
                        let msg_ta = json["msg_ta"].stringValue
                        let status = json["status"].stringValue
                        if msg == "Tracking found" && status == "success"{
                            self.latitude = json["track_info"]["lat"].doubleValue
                            self.longitude = json["track_info"]["lon"].doubleValue
                            self.startTimer()
                            self.locationManager.startUpdatingLocation()
                        }
                        else
                        {
                            
                            if LocalizationSystem.sharedInstance.getLanguage() == "en"
                            {
                                Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_en) { (action) in
                                    //Custom action code
                                    self.navigationController?.popViewController(animated: true)

                                }
                            }
                            else
                            {
                                Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_ta) { (action) in
                                    //Custom action code
                                    self.navigationController?.popViewController(animated: true)

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
    
    @IBAction func callAction(_ sender: Any)
    {
        self.callNumber(phoneNumber: (serviceListDetail?.person_number!)!)
    }
    
    func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
