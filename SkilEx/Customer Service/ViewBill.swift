//
//  ViewBill.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 19/08/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class ViewBill: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var billArr = [Bill]()
    var serviceOrderId = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addBackButton()
        self.webRequestForBill()
        self.preferedLanguage()

    }
    
    @objc public override func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.preferedLanguage()
    }

    func preferedLanguage () {
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "viewbillnavtitle_text", comment: "")
    }
    
    func webRequestForBill ()
    {
        let parameters = ["service_order_id": serviceOrderId, "user_master_id": GlobalVariables.shared.user_master_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "service_order_bills", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
                        let msg = json["msg"].stringValue
                        let msg_en = json["msg_en"].stringValue
                        let msg_ta = json["msg_ta"].stringValue
                        let status = json["status"].stringValue
                        if msg == "Service Bill Found" && status == "success"
                        {
                            
                            for i in 0..<json["service_bill"].count {
                                
                                let bill = Bill.init(json: json["service_bill"][i])
                                self.billArr.append(bill)
                            }
                            
                            self.collectionView.reloadData()
                        }
                        else
                        {
                            if LocalizationSystem.sharedInstance.getLanguage() == "en"
                            {
                                Alert.defaultManager.showOkAlert("SkilEx", message: msg_en) { (action) in
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return billArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryCollectionViewCell
        
        let bill = billArr[indexPath.row]
        let imgUrl = bill.file_bill
        if imgUrl!.isEmpty == false
        {
            let url = URL(string: imgUrl!)
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.categoeryImage.image = image
                            
                        }
                    }
                }
            }
        }
        
         cell.cellView.dropShadow(offsetX: 0, offsetY: 1, color: UIColor.gray, opacity: 0.3, radius: 3)

         return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.collectionView
        {
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryCollectionViewCell
            let index = billArr[indexPath.row]
            let imgUrl = index.file_bill!
            if  imgUrl.isEmpty == false
            {
                let url = URL(string: imgUrl)
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.categoeryImage.image = image
                                let newImageView = UIImageView(image: cell.categoeryImage.image)
                                newImageView.frame = UIScreen.main.bounds
                                newImageView.backgroundColor = .black
                                newImageView.contentMode = .scaleAspectFit
                                newImageView.isUserInteractionEnabled = true
                                let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage))
                                newImageView.addGestureRecognizer(tap)
                                self.view.addSubview(newImageView)
                                self.navigationController?.isNavigationBarHidden = true
                                self.tabBarController?.tabBar.isHidden = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 130, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        let yourWidth = collectionView.bounds.width/3.0
        let yourHeight = yourWidth
            
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2,left: 0,bottom: 0,right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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

