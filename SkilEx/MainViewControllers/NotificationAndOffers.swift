//
//  NotificationAndOffers.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 31/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class NotificationAndOffers: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var notificationArr = [Notifications]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addBackButton()
        self.preferedLanguage()
        self.webRequestNotificationAndOffers()
        tableView.tableFooterView = UIView()
    }
    
    @objc public override func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func preferedLanguage()
    {
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "notificationnavtitle_text", comment: "")
    }
    
    func webRequestNotificationAndOffers ()
    {
        let parameters = ["user_master_id": GlobalVariables.shared.user_master_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "service_pending_and_offers_list", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let status = json["status"].stringValue
                        if msg == "Service and offer list" && status == "success"
                        {
                            if json["offer_response"].count > 0 {
                                
                                for i in 0..<json["offer_response"].count {
                                    
                                    let notification = Notifications.init(json: json["offer_response"][i])
                                    self.notificationArr.append(notification)
                                    
                                }
                                    self.tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NotificationAndOffersTableViewCell
        let notification = notificationArr[indexPath.row]
        cell.offersLabel.text = notification.offer_description
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79
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
