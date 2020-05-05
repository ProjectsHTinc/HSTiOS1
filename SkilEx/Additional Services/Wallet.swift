//
//  Wallet.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 28/04/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class Wallet: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var WalletDataArr = [WalletData]()

    @IBOutlet weak var skilexWalletLabel: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var addMoneyOutlet: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.isHidden = true
        self.checkWalletBalanceAndHistory ()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.preferedLanguage()
        self.addBackButton()
        addMoneyOutlet.addShadowToButton(color: UIColor.gray, cornerRadius: self.addMoneyOutlet.frame.height / 2, backgroundcolor: UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0))
        self.checkWalletBalanceAndHistory ()

    }
    
    func preferedLanguage()
    {
        self.navigationItem.title =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "amountStatusnavtitle_text", comment: "")
    }
    
    @objc public override func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkWalletBalanceAndHistory ()
    {
        let parameters = ["user_master_id": GlobalVariables.shared.user_master_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.BASE_URL + "check_wallet_balance_and_history", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
//                        let msg = json["msg"].stringValue
                        let msg_en = json["result_wallet"]["msg_en"].stringValue
                        let msg_ta = json["result_wallet"]["msg_ta"].stringValue
                        let status = json["status"].stringValue
//                        let result_wallet = json["result_wallet"].stringValue
                        if  status == "success"{
                           let wallet_balance = json["wallet_balance"].stringValue
                           self.updateWalletBalance(walletBalance: wallet_balance)
                            if msg_en == "wallet history found"
                            {
                                if json["result_wallet"]["wallet_data"].count > 0
                                {
                                    for i in 0..<json["result_wallet"]["wallet_data"].count
                                    {
                                      let Walletdata = WalletData.init(json: json["result_wallet"]["wallet_data"][i])
                                      self.WalletDataArr.append(Walletdata)
                                      self.tableView.isHidden = false
                                    }
                                    
                                      self.tableView.reloadData()
                                }
                            }
                                                       
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
    
    
    func updateWalletBalance (walletBalance:String)
    {
        if walletBalance.isEmpty
        {
            self.amount.text = "₹ 0"
        }
        else
        {
            self.amount.text = "₹" + "" + walletBalance
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WalletDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WalletDetailCell
        let walletdata = WalletDataArr[indexPath.row]
        
        let date = Date()
        cell.date.text = date.formattedDateFromString(dateString: walletdata.created_date!, withFormat:"dd MMM YYYY")
        cell.addAMountLabel.text = walletdata.notes
        cell.addAmountTimeLabel.text = walletdata.created_time
        cell.addAmount.text = walletdata.transaction_amt
        
        cell.addView.dropShadow()

        return cell
    }
            
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
    
    @IBAction func addMoneyAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "to_AddMoneyToWallet", sender: self)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
//        if (segue.identifier == "to_UserProfile")
//        {
//            let vc = segue.destination as! Tabbarcontroller
//            vc.selectedIndex = 2
//        }
    }
    

}
