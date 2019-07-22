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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "homenavtitle_text", comment: "")
        self.addrightButton()
        self.updateViewBorders()
    }
    
    @objc public override func backButtonClick(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateViewBorders()
    {
        viewOne.addbordercolorToUIView(cornerRadius: 5.0, bordercolor: UIColor(red: 76/255, green: 183/255, blue: 191/255, alpha: 1.0), borderwidth: 1.0, backgroundColor: UIColor.white)
        viewOneImgView.addbordercolorToUIView(cornerRadius: 5.0, bordercolor: UIColor.clear, borderwidth: 0, backgroundColor: UIColor(red: 76/255, green: 183/255, blue: 191/255, alpha: 1.0))
        viewOne.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: -1), radius: 3, scale: true, cornerradius: 5)
    
        viewTwo.addbordercolorToUIView(cornerRadius: 5.0, bordercolor: UIColor(red: 174/255, green: 132/255, blue: 187/255, alpha: 1.0), borderwidth: 1.0, backgroundColor: UIColor.white)
        viewTwoImgView.addbordercolorToUIView(cornerRadius: 5.0, bordercolor: UIColor.clear, borderwidth: 0, backgroundColor: UIColor(red: 174/255, green: 132/255, blue: 191/255, alpha: 1.0))
        viewTwo.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: -1), radius: 3, scale: true, cornerradius: 5)
        
        viewThree.addbordercolorToUIView(cornerRadius: 5.0, bordercolor: UIColor(red: 236/255, green: 56/255, blue: 82/255, alpha: 1.0), borderwidth: 1.0, backgroundColor: UIColor.white)
        viewThreeImgView.addbordercolorToUIView(cornerRadius: 5.0, bordercolor: UIColor.clear, borderwidth: 0, backgroundColor: UIColor(red: 236/255, green: 56/255, blue: 82/255, alpha: 1.0))
        viewThree.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: -1), radius: 3, scale: true, cornerradius: 5)
    }
    
    @IBAction func requestServiceButtonAction(_ sender: Any)
    {
        
    }
    
    @IBAction func onGoingButtonAction(_ sender: Any)
    {
        
    }
    
    @IBAction func serviceHistoryButtonAction(_ sender: Any)
    {
        
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
