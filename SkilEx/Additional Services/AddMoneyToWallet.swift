//
//  AddMoneyToWallet.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 29/04/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit

class AddMoneyToWallet: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var addMoneyToLabel: UILabel!
    @IBOutlet weak var skilexWalletLabel: UILabel!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var proceedOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        amount.delegate = self
        self.addToolBar(textField: amount)
        //view.bindToKeyboard()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.preferedLanguage()
        self.addBackButton()
        proceedOutlet.addShadowToButton(color: UIColor.gray, cornerRadius: self.proceedOutlet.frame.height / 2, backgroundcolor: UIColor(red: 19.0/255, green: 90.0/255, blue: 160.0/255, alpha: 1.0))
    }
    
    func preferedLanguage()
    {
        self.navigationItem.title =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "SkilexWalletnavtitle_text", comment: "")
        self.addMoneyToLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "SkilexWalletaddmoney_text", comment: "")
        self.skilexWalletLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "SkilexWalletnavtitle_text", comment: "")
        proceedOutlet.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "advancepaymentproceed_text", comment: ""), for: .normal)
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            NSAttributedString.Key.font : UIFont(name: "Helvetica", size: 13)! // Note the !
        ]
        self.amount.attributedPlaceholder = NSAttributedString(string: LocalizationSystem.sharedInstance.localizedStringForKey(key: "SkilexWalletaddmoneyAmount_text", comment: ""), attributes:attributes)
    }
    
    @objc public override func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
        //self.performSegue(withIdentifier: "back", sender: self)
    }
    
    func generateRandomDigits(_ digitNumber: Int) -> String {
        var number = ""
        for i in 0..<digitNumber {
            var randomNumber = arc4random_uniform(10)
            while randomNumber == 0 && i == 0 {
                randomNumber = arc4random_uniform(10)
            }
            number += "\(randomNumber)"
        }
        return number
    }
    
    func addToWalletByPaymemtGateway (amount:String)
    {
        let randomNumbers = Int(generateRandomDigits(5))
        print(randomNumbers!)
        
        let concordinateString = "\(randomNumbers!)" + "-" + GlobalVariables.shared.user_master_id
        print(concordinateString)
        UserDefaults.standard.set("MW", forKey: "Advance/customer")
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "CCWebViewController") as! CCWebViewController
        viewController.accessCode = "AVQM86GG76CA98MQAC"
        viewController.merchantId = "225068"
        viewController.amount = amount
        // advance_amount
        viewController.strAddMoneyToWallet = concordinateString
        viewController.currency = "INR"
        viewController.orderId = concordinateString
        viewController.redirectUrl = String(format: "%@%@", AFWrapper.PaymentBaseUrl,"ccavenue_app/adding_money_to_wallet.php")
        viewController.cancelUrl = String(format: "%@%@", AFWrapper.PaymentBaseUrl,"ccavenue_app/adding_money_to_wallet.php")
        viewController.rsaKeyUrl = String(format: "%@%@", AFWrapper.PaymentBaseUrl,"ccavenue_app/GetRSA.php")
                
        self.present(viewController, animated: true, completion: nil)

    }
    
    @IBAction func proceedAction(_ sender: Any)
    {
        if amount.text!.isEmpty
        {
            Alert.defaultManager.showOkAlert(LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "advancepaymentproceed_text", comment: "")) { (action) in
                //Custom action code
            }
        }
        else
        {
            self.addToWalletByPaymemtGateway(amount: self.amount.text!)
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
