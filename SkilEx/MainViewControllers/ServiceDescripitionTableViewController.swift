//
//  ServiceDescripitionTableViewController.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 22/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD
import SDWebImage

class ServiceDescripitionTableViewController: UITableViewController {
    
    var reviewArr = [ReviewData]()
    var rows = Int()

    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var inclusionText: UILabel!
    @IBOutlet weak var exclusionText: UILabel!
    @IBOutlet weak var procedureText: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var othersLabel: UILabel!
    @IBOutlet weak var booknowOutlet: UIButton!
    @IBOutlet weak var inclusionLabel: UILabel!
    @IBOutlet weak var exclusionLabel: UILabel!
    @IBOutlet weak var procedureLabel: UILabel!
    @IBOutlet weak var othertitleLabel: UILabel!
    @IBOutlet var reviewImageView: UIImageView!
    @IBOutlet var reviewName: UILabel!
    @IBOutlet var reviewDate: UILabel!
    @IBOutlet var reviewStatus: UILabel!
    @IBOutlet var reviewStarOne: UIImageView!
    @IBOutlet var reviewStartTwo: UIImageView!
    @IBOutlet var reviewStartThree: UIImageView!
    @IBOutlet var reviewStartFour: UIImageView!
    @IBOutlet var reviewStartFive: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.reviewWebserviceCall ()
        
        if LocalizationSystem.sharedInstance.getLanguage() == "en"
        {
            inclusionLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicediscripitionInclusion_text", comment: "")
            exclusionLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicediscripitionExclusion_text", comment: "")
            procedureLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicediscripitionProcedure_text", comment: "")
            othertitleLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicediscripitionOthers_text", comment: "")
            booknowOutlet.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicediscripitionbooknwBtn_text", comment: ""), for: .normal)
            
            let serviceDetail = UserDefaults.standard.getServicesDescripition()
            self.serviceName.text = serviceDetail?.rate_card_details
            self.amountLabel.text = String(format: "%@ %@","₹.",(serviceDetail?.rate_card!)!)
            self.inclusionText.text = serviceDetail?.inclusions
            self.exclusionText.text = serviceDetail?.exclusions
            self.procedureText.text = serviceDetail?.service_procedure
            self.othersLabel.text = serviceDetail?.others
        }
        else
        {
            inclusionLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicediscripitionInclusion_text", comment: "")
            exclusionLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicediscripitionExclusion_text", comment: "")
            procedureLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicediscripitionProcedure_text", comment: "")
            othertitleLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicediscripitionOthers_text", comment: "")
            booknowOutlet.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "servicediscripitionbooknwBtn_text", comment: ""), for: .normal)
            
            let serviceDetail = UserDefaults.standard.getServicesDescripition()
            self.serviceName.text = serviceDetail?.rate_card_details_ta
            self.amountLabel.text = String(format: "%@ %@","₹.",(serviceDetail?.rate_card!)!)
            self.inclusionText.text = serviceDetail?.inclusions_ta
            self.exclusionText.text = serviceDetail?.exclusions_ta
            self.procedureText.text = serviceDetail?.service_procedure_ta
            self.othersLabel.text = serviceDetail?.others_ta

        }
        self.rows = 5
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
//        if LocalizationSystem.sharedInstance.getLanguage() == "en"
//        {
//            let serviceDetail = UserDefaults.standard.getServicesDescripition()
//            self.serviceName.text = serviceDetail?.rate_card_details
//            self.amountLabel.text = String(format: "%@ %@","Rs.",(serviceDetail?.rate_card!)!)
//            self.inclusionText.text = serviceDetail?.inclusions
//            self.exclusionText.text = serviceDetail?.exclusions
//            self.procedureText.text = serviceDetail?.service_procedure
//            self.othersLabel.text = serviceDetail?.others
//
//        }
//        else
//        {
//            let serviceDetail = UserDefaults.standard.getServicesDescripition()
//            self.serviceName.text = serviceDetail?.rate_card_details_ta
//            self.amountLabel.text = String(format: "%@ %@","Rs.",(serviceDetail?.rate_card!)!)
//            self.inclusionText.text = serviceDetail?.inclusions_ta
//            self.exclusionText.text = serviceDetail?.exclusions_ta
//            self.procedureText.text = serviceDetail?.service_procedure_ta
//            self.othersLabel.text = serviceDetail?.others_ta
//
//        }
    }
    
    func reviewWebserviceCall ()
    {
        let url = AFWrapper.BASE_URL + "service_rating_and_reviews"
        let parameters = ["user_master_id": GlobalVariables.shared.user_master_id,"service_id": GlobalVariables.shared.serviceId]
//        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(url, params: (parameters), headers: nil, success: {
                        (JSONResponse) -> Void in
//                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
//                        let msg_en = json["msg_en"].stringValue
//                        let msg_ta = json["msg_ta"].stringValue
                        let status = json["status"].stringValue
                        if msg == "View Services reviews and rating" && status == "success"
                        {
                            self.reviewArr.removeAll()
                            self.rows = 6
                            if json["services_reviews"].count > 0 {
                                
                                for i in 0..<json["services_reviews"].count {
                                    
                                    let servicesReviews = ReviewData.init(json: json["services_reviews"][i])
                                    UserDefaults.standard.saveReviewDetails(reviewData: servicesReviews)
                                    self.updateValues ()

                                }
                            }
                            self.tableView.reloadData()
                        
                        }
                        else
                        {
                            self.rows = 5
                            self.tableView.reloadData()
//                            if LocalizationSystem.sharedInstance.getLanguage() == "en"
//                            {
//                                Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_en) { (action) in
//                                    // Custom action code
//                               }
//                            }
//                            else
//                            {
//                                Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_ta) { (action) in
//                                    // Custom action code
//                                 }
//                            }
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
        let reviewData = UserDefaults.standard.getReviewDetails()
        self.reviewArr.append(reviewData!)
        
        for items in reviewArr
        {
            if let userImg = items.profile_picture
            {
                self.reviewImageView.sd_setImage(with: URL(string: userImg), placeholderImage: UIImage(named: "user"))
                self.reviewImageView.clipsToBounds = true
            }
            self.reviewName.text = items.customer_name
            self.reviewDate.text = items.review_date
            
            let rating = items.rating
            if rating == "1"
            {
                self.reviewStarOne.image = UIImage(named: "ios_icons-31")
                self.reviewStartTwo.image = UIImage(named: "ios_icons-32")
                self.reviewStartThree.image = UIImage(named: "ios_icons-32")
                self.reviewStartFour.image = UIImage(named: "ios_icons-32")
                self.reviewStartFive.image = UIImage(named: "ios_icons-32")
                
                self.reviewStatus.text = "Poor"
            }
            else if rating == "2"
            {
                self.reviewStarOne.image = UIImage(named: "ios_icons-31")
                self.reviewStartTwo.image = UIImage(named: "ios_icons-31")
                self.reviewStartThree.image = UIImage(named: "ios_icons-32")
                self.reviewStartFour.image = UIImage(named: "ios_icons-32")
                self.reviewStartFive.image = UIImage(named: "ios_icons-32")
                
                self.reviewStatus.text = "Average"

            }
            else if rating == "3"
            {
                self.reviewStarOne.image = UIImage(named: "ios_icons-31")
                self.reviewStartTwo.image = UIImage(named: "ios_icons-31")
                self.reviewStartThree.image = UIImage(named: "ios_icons-31")
                self.reviewStartFour.image = UIImage(named: "ios_icons-32")
                self.reviewStartFive.image = UIImage(named: "ios_icons-32")
                
                self.reviewStatus.text = "Good!"
            }
            else if rating == "4"
            {
                self.reviewStarOne.image = UIImage(named: "ios_icons-31")
                self.reviewStartTwo.image = UIImage(named: "ios_icons-31")
                self.reviewStartThree.image = UIImage(named: "ios_icons-31")
                self.reviewStartFour.image = UIImage(named: "ios_icons-31")
                self.reviewStartFive.image = UIImage(named: "ios_icons-32")
                
                self.reviewStatus.text = "Very Good!!"
            }
            else if rating == "5"
            {
                self.reviewStarOne.image = UIImage(named: "ios_icons-31")
                self.reviewStartTwo.image = UIImage(named: "ios_icons-31")
                self.reviewStartThree.image = UIImage(named: "ios_icons-31")
                self.reviewStartFour.image = UIImage(named: "ios_icons-31")
                self.reviewStartFive.image = UIImage(named: "ios_icons-31")
                
                self.reviewStatus.text = "Excellent!!!"

            }
            break
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rows
    }
    
    @IBAction func bookNowAction(_ sender: Any)
    {
        if GlobalVariables.shared.user_master_id .isEmpty == true
        {
          let alertController = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "homealertmsg_text", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            
            let okAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "login_text", comment: ""), style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.performSegue(withIdentifier: "to_Login", sender: self)
            }
            let cancelAction = UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "cancel", comment: ""), style: UIAlertAction.Style.default) {
                UIAlertAction in
            }
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            self.serviceAddToCart(user_master_id: GlobalVariables.shared.user_master_id, category_id: GlobalVariables.shared.main_catID, sub_category_id: GlobalVariables.shared.sub_catID, service_id: GlobalVariables.shared.catServicetID)
        }
       
    }
    
    func serviceAddToCart(user_master_id: String, category_id: String, sub_category_id: String, service_id:String)
    {
            let url = AFWrapper.BASE_URL + "add_service_to_cart"
            let parameters = ["user_master_id": user_master_id, "category_id": category_id, "sub_category_id": sub_category_id, "service_id": service_id]
            MBProgressHUD.showAdded(to: self.view, animated: true)
            DispatchQueue.global().async
                {
                    do
                    {
                        try AFWrapper.requestPOSTURL(url, params: (parameters), headers: nil, success: {
                            (JSONResponse) -> Void in
                            print(JSONResponse)
                            MBProgressHUD.hide(for: self.view, animated: true)
                            let json = JSON(JSONResponse)
                            let msg = json["msg"].stringValue
                            let msg_en = json["msg_en"].stringValue
                            let msg_ta = json["msg_ta"].stringValue
                            let status = json["status"].stringValue
                            if msg == "Service added to cart" && status == "success"
                            {
//                                let cart_total = json["cart_total"]
//                                print(cart_total as Any)
                                self.performSegue(withIdentifier: "viewSummary", sender: self)
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
    
    @IBAction func reviewAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "to_Review", sender: self)
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
        
        if (segue.identifier == "viewSummary"){
            
            let _ = segue.destination as! ViewSummary
        }
        else if (segue.identifier == "to_Review")
        {
            let _ = segue.destination as! Review
        }
    }
    

}
