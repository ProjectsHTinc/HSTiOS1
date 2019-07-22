//
//  Home.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 28/06/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class Home: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate
{
    var bannerImage = [String]()
    var index = 0
    var inForwardDirection = true
    var timer: Timer?
    var categoeryArr = [Categories]()
    var banner_Image = [BannerImages]()
    var subcategoeryArr = [String]()
    var subcategoeryID = [String]()
    var cat_id = String()
    
    @IBOutlet var bannerCollectionView: UICollectionView!
    @IBOutlet var categoryCollectionView: UICollectionView!
    @IBOutlet weak var searchTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "homenavtitle_text", comment: "")
        self.addrightButton() 
        self.viewMainCategoery()
        self.viewBanners()
        self.categoryCollectionView.isUserInteractionEnabled = true
        self.hideKeyboardWhenTappedAround()
        self.searchTextfield.delegate = self
        self.searchTextfield.addShadowToTextField(cornerRadius: 5.0)
        self.searchTextfield.addShadowToTextField(color: UIColor.gray, cornerRadius: 5.0)
        self.searchTextfield.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "homesearchbar_text", comment: "")
    }
    
    func viewBanners()
    {
        let url = AFWrapper.BASE_URL + "view_banner_list"
        let parameters = ["user_master_id": GlobalVariables.shared.user_master_id]
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
                        if msg == "View banner list" && status == "success"
                        {
                            if json["banners"].count > 0 {
                                
                                for i in 0..<json["banners"].count {
                                    let banner = BannerImages.init(json: json["banners"][i])
                                    self.banner_Image.append(banner)
                                    let bannerImg = banner.banner_img
                                    self.bannerImage.append(bannerImg!)
                                }
                                    self.startTimer()
                                    self.bannerCollectionView.reloadData()
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
    
    func viewMainCategoery()
    {
        let url = AFWrapper.BASE_URL + "view_maincategory"
        let parameters = ["user_master_id": GlobalVariables.shared.user_master_id]
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
                        if msg == "View Category" && status == "success"
                        {
                            if json["categories"].count > 0 {
                                
                                for i in 0..<json["categories"].count {
                                    
                                    let categoery = Categories.init(json: json["categories"][i])
                                    self.categoeryArr.append(categoery)
                                }
                                   self.categoryCollectionView.reloadData()
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
            timer = Timer.scheduledTimer(timeInterval: 6.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true);
        }
    }
    
    @objc func scrollToNextCell() {
        
        //scroll to next cell
        let items = bannerCollectionView.numberOfItems(inSection: 0)
        if (items - 1) == index {
            bannerCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
        } else if index == 0 {
            bannerCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
        } else {
            bannerCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }
        
        if inForwardDirection {
            if index == (items - 1) {
                index -= 1
                inForwardDirection = false
            } else {
                index += 1
            }
        } else {
            if index == 0 {
                index += 1
                inForwardDirection = true
            } else {
                index -= 1
            }
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == self.bannerCollectionView
        {
             return banner_Image.count 
        }
        else
        {
            return categoeryArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if collectionView == bannerCollectionView
        {
            let cell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BannerCollectionViewCell
            let bannerImg = banner_Image[indexPath.row]
            let imgUrl = bannerImg.banner_img
            if imgUrl!.isEmpty == false
            {
                let url = URL(string: imgUrl!)
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.bannerImageView.image = image
                            }
                        }
                    }
                }
            }
            
            return cell
        }
        else
        {
            if LocalizationSystem.sharedInstance.getLanguage() == "en"
            {
                let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "Categorycell", for: indexPath) as! CategoryCollectionViewCell
                cell.cellView.dropShadow(color: .gray, opacity: 0.2, offSet: CGSize(width: -1, height: -1), radius: 0, scale: true, cornerradius: 0)
                let categoery = categoeryArr[indexPath.row]
                cell.categoeryName.text =  categoery.cat_name
                let imgUrl = categoery.cat_pic_url
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
                return cell
            }
            else
            {
                let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "Categorycell", for: indexPath) as! CategoryCollectionViewCell
                cell.cellView.dropShadow(color: .gray, opacity: 0.2, offSet: CGSize(width: -1, height: -1), radius: 0, scale: true, cornerradius: 0)
                let categoery = categoeryArr[indexPath.row]
                cell.categoeryName.text =  categoery.cat_ta_name
                let imgUrl = categoery.cat_pic_url
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
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == categoryCollectionView
        {
            guard categoryCollectionView.cellForItem(at: indexPath as IndexPath) != nil else { return }
            let index = categoeryArr[indexPath.row]
            cat_id = index.cat_id!
            print(cat_id)
            self.viewSubCategoery(categoeryId: cat_id)
        }
    }
    
    func viewSubCategoery (categoeryId: String)
    {
        let url = AFWrapper.BASE_URL + "view_subcategory"
        let parameters = ["main_cat_id": categoeryId]
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
                        if msg == "View Sub Category" && status == "success"
                        {
                            if json["sub_categories"].count > 0 {
                                
                                self.subcategoeryArr.removeAll()
                                self.subcategoeryID.removeAll()
                                for i in 0..<json["sub_categories"].count
                                {
                                    
                                    let subCategoery = SubCategories.init(json: json["sub_categories"][i])
                                    let subCategoeryID = subCategoery.sub_cat_id
                                    self.subcategoeryID.append(subCategoeryID!)
                                    if LocalizationSystem.sharedInstance.getLanguage() == "en"
                                    {
                                        let subCategoeryName = subCategoery.sub_cat_name
                                        self.subcategoeryArr.append(subCategoeryName!)
                                    }
                                    else
                                    {
                                        let subCategoeryName = subCategoery.sub_cat_ta_name
                                        self.subcategoeryArr.append(subCategoeryName!)
                                    }
                                }
                                
                                self.performSegue(withIdentifier: "serviceDetail", sender: self)
                                
                              }
                        }
                        else
                        {
                            Alert.defaultManager.showOkAlert("SkilEx", message: msg) { (action) in
                                
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

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView == categoryCollectionView
        {
            let yourWidth = categoryCollectionView.bounds.width/3.0
            let yourHeight = yourWidth
            
            return CGSize(width: yourWidth, height: yourHeight)
        }
        else
        {
            return CGSize(width:self.bannerCollectionView.bounds.width, height: self.bannerCollectionView.bounds.height)
        }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == searchTextfield
        {
            self.performSegue(withIdentifier: "search", sender: self)
        }
        return true
    }
    @IBAction func searchFieldCloseButton(_ sender: Any) {
        
        searchTextfield.text = ""
        searchTextfield.resignFirstResponder()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "serviceDetail") {
            let vc = segue.destination as! ServiceDetail
            vc.subcategoeryNameArr = self.subcategoeryArr
            vc.subcategoeryIDArr = self.subcategoeryID
            vc.main_cat_id = self.cat_id
        }
        else if (segue.identifier == "search")
        {
            let vc = segue.destination as! SearchResult
            vc.searchtext = self.searchTextfield.text!
        }

    }
}

