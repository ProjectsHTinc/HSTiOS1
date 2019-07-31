//
//  Service.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 28/06/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class Service: UIViewController{
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewOne: UIView!
    @IBOutlet var viewTwo: UIView!
    @IBOutlet var viewThree: UIView!
    @IBOutlet var viewOneImgView: UIView!
    @IBOutlet var viewTwoImgView: UIView!
    @IBOutlet var viewThreeImgView: UIView!
    @IBOutlet weak var requestServiceLabel: UILabel!
    @IBOutlet weak var ongoingServiceLabel: UILabel!
    @IBOutlet weak var serviceHistoryLabel: UILabel!
    @IBOutlet weak var servicesTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated:true);
        self.preferedLanguage()
    }
    
    func preferedLanguage()
    {
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "homenavtitle_text", comment: "")
        servicesTitleLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicestitle_text", comment: "")
        requestServiceLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesrequested_text", comment: "")
        ongoingServiceLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesongoing_text", comment: "")
        serviceHistoryLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicesService_text", comment: "")
    }
    
    
    @IBAction func requestServiceButtonAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "requestedService", sender: self)
    }
    
    @IBAction func onGoingButtonAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "ongoingService", sender: self)
    }
    
    @IBAction func serviceHistoryButtonAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "serviceHistory", sender: self)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "ongoingService")
        {
            let _ = segue.destination as! OnGoing_Service
        }
        else if (segue.identifier == "requestedService")
        {
            let _ = segue.destination as! RequestedService
        }
        else if (segue.identifier == "serviceHistory"){
            let _ = segue.destination as! ServiceHistory
        }
    }
    

}
