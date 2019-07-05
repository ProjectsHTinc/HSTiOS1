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

class Home: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate
{
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
   
    var bannerImage = [UIImage]()
    var index = 0
    var inForwardDirection = true
    var timer: Timer?
    var categoeryArr = [Categories]()
    
    var filtered = [Categories]()
    var searchActive : Bool = false
    let searchController = UISearchController(searchResultsController: nil)

    
    @IBOutlet var bannerCollectionView: UICollectionView!
    @IBOutlet var categoryCollectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //let userdata = UserDefaults.standard.getUserData()
        let url = AFWrapper.BASE_URL + "view_maincategory"
        let parameters = ["user_master_id": "1"]
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
        
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.clipsToBounds = true
        self.definesPresentationContext = true
        self.searchBar.backgroundImage = UIImage(named: "search_box.png")
        searchController.searchBar.sizeToFit()
        searchController.searchBar.becomeFirstResponder()

        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.white
            textfield.backgroundColor = UIColor.white
            
        }
        
        //self.hideKeyboardWhenTappedAround()
        bannerImage = [UIImage(named: "physiotherapy-1.png"),UIImage(named: "physiotherapy-2.png"),UIImage(named: "physiotherapy-3.png")] as! [UIImage]
        startTimer()
    }
    
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true);
        }    }
    
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
        if collectionView == self.bannerCollectionView {
             return bannerImage.count 
        }
        else
        {
            if searchActive
            {
                return filtered.count
            }
            else
            {
                return categoeryArr.count
            }
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        if collectionView == bannerCollectionView
        {
            let cell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BannerCollectionViewCell
            cell.bannerImageView.image = bannerImage[indexPath.row]
            
            return cell
        }
        
        if searchActive
        {
            let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "Categorycell", for: indexPath) as! CategoryCollectionViewCell
            cell.cellView.dropShadow(color: .gray, opacity: 0.2, offSet: CGSize(width: -1, height: -1), radius: 0, scale: true, cornerradius: 3)
            let filter = filtered[indexPath.row]
            cell.categoeryName.text =  filter.cat_name
            let imgUrl = filter.cat_pic_url
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
            cell.cellView.dropShadow(color: .gray, opacity: 0.2, offSet: CGSize(width: -1, height: -1), radius: 0, scale: true, cornerradius: 3)
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
    }
    
    private  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if collectionView == categoryCollectionView
        {
            guard let cell = categoryCollectionView.cellForItem(at: indexPath as IndexPath) else { return }
            
            performSegue(withIdentifier: "showDetail", sender: cell)
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
    
    //MARK: Search Bar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if let searchText = searchBar.text {
            
            if searchText != "" {
                searchActive = true
                filtered = categoeryArr.filter({$0.cat_name!.contains(searchText) || $0.cat_name!.contains(searchText)})
                categoryCollectionView.reloadData()
            }
            else {
                searchActive = false
                filtered = categoeryArr
                categoryCollectionView.reloadData()
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = false
        categoryCollectionView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        categoryCollectionView.reloadData()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        switch segue.identifier {
        case "showDetail":
            guard let indexPath = (sender as? UIView)?.findCollectionViewIndexPath() else { return }
            guard let vc = segue.destination as? ServiceDetail else { return }
            
            let categoery = categoeryArr[indexPath.row]
            vc.main_cat_id = categoery.cat_id!
            
        default: return
        }
    }

}
