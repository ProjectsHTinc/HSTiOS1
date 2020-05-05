//
//  Review.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 05/05/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class Review: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var reviewArr = [ReviewData]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addBackButton()
        self.reviewForServices ()
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.preferedLanguage()

    }
    
    func preferedLanguage()
    {
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "reviewAndRatingsnavtitle_text", comment: "")

    }
    
    @objc public override func backButtonClick()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func reviewForServices ()
    {
        let url = AFWrapper.BASE_URL + "service_rating_and_reviews"
        let parameters = ["user_master_id": GlobalVariables.shared.user_master_id,"service_id":  GlobalVariables.shared.serviceID]
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
                        let msg_en = json["msg_en"].stringValue
                        let msg_ta = json["msg_ta"].stringValue
                        let status = json["status"].stringValue
                        if msg == "View Services reviews and rating" && status == "success"
                        {
                            self.reviewArr.removeAll()

                            if json["services_reviews"].count > 0 {
                                
                                for i in 0..<json["services_reviews"].count {
                                    
                                    let categoery = ReviewData.init(json: json["services_reviews"][i])
                                    self.reviewArr.append(categoery)
                                }
                                   self.tableView.reloadData()
                            }
                        
                        }
                        else
                        {
                            if LocalizationSystem.sharedInstance.getLanguage() == "en"
                            {
                                Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: msg_en) { (action) in
                                    // Custom action code
                               }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReviewTableViewCell
        let reviews = reviewArr[indexPath.row]
        cell.nameText.text = reviews.customer_name
        cell.descripition.text = reviews.review
        let rating = reviews.rating
        if (rating == "1")
        {
            cell.imageOne.image = UIImage(named: "RatingBlueStar")
            cell.imageTwo.image = UIImage(named: "ios_icons-32")
            cell.imageThree.image = UIImage(named: "ios_icons-32")
            cell.imagefour.image = UIImage(named: "ios_icons-32")
            cell.imageFive.image = UIImage(named: "ios_icons-32")

        }
        else if (rating == "2")
        {
            cell.imageOne.image = UIImage(named: "RatingBlueStar")
            cell.imageTwo.image = UIImage(named: "RatingBlueStar")
            cell.imageThree.image = UIImage(named: "ios_icons-32")
            cell.imagefour.image = UIImage(named: "ios_icons-32")
            cell.imageFive.image = UIImage(named: "ios_icons-32")
        }
        else if (rating == "3")
        {
            cell.imageOne.image = UIImage(named: "RatingBlueStar")
            cell.imageTwo.image = UIImage(named: "RatingBlueStar")
            cell.imageThree.image = UIImage(named: "RatingBlueStar")
            cell.imagefour.image = UIImage(named: "ios_icons-32")
            cell.imageFive.image = UIImage(named: "ios_icons-32")
        }
        else if (rating == "4")
        {
            cell.imageOne.image = UIImage(named: "RatingBlueStar")
            cell.imageTwo.image = UIImage(named: "RatingBlueStar")
            cell.imageThree.image = UIImage(named: "RatingBlueStar")
            cell.imagefour.image = UIImage(named: "RatingBlueStar")
            cell.imageFive.image = UIImage(named: "ios_icons-32")
        }
        else if (rating == "5")
        {
            cell.imageOne.image = UIImage(named: "RatingBlueStar")
            cell.imageTwo.image = UIImage(named: "RatingBlueStar")
            cell.imageThree.image = UIImage(named: "RatingBlueStar")
            cell.imagefour.image = UIImage(named: "RatingBlueStar")
            cell.imageFive.image = UIImage(named: "RatingBlueStar")
        }
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
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
