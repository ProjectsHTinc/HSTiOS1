//
//  CCWebViewController.swift
//  CCIntegrationKit_Swift
//
//  Created by Ram Mhapasekar on 7/4/17.
//  Copyright © 2017 Ram Mhapasekar. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import MBProgressHUD
//import OpenSSL

/**
 * class: CCWebViewController
 * CCWebViewController is responsible for to take all the values from the merchant and process futher for the payment
 * We will generate the RSA Key for this transaction first by using access code of the merchant and the unique order id for this transaction
 * After generating Successful RSA Key we will use that key for encrypting amount and currency and the encrypted details will use for intiate the transaction
 * Once the transaction is done  we will pass the transaction result to the next page (ie CCResultViewController here)
 */

class CCWebViewController: UIViewController,UIWebViewDelegate, UIViewControllerTransitioningDelegate
{
    
    var accessCode = String()
    var merchantId = String()
    var orderId = String()
    var amount = String()
    var currency = String()
    var redirectUrl = String()
    var cancelUrl = String()
    var rsaKeyUrl = String()
    var rsaKeyDataStr = String()
    var rsaKey = String()
    static var statusCode = 0//zero means success or else error in encrption with rsa
    var encVal = String()
    
    var strAddMoneyToWallet = String()
    
    var transStatus = String()
    var advancePayment = String()
    
    lazy var viewWeb: UIWebView = {
        let webView = UIWebView()
        webView.backgroundColor = .white
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.delegate = self
        webView.scalesPageToFit = true
        webView.contentMode = UIView.ContentMode.scaleAspectFill
        return webView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        advancePayment = UserDefaults.standard.string(forKey: "Advance/customer")!
        print(advancePayment)
        setupWebView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        /**
         * In viewWillAppear we will call gettingRsaKey method to generate RSA Key for the transaction and use the same to encrypt data
         */
        
        self.gettingRsaKey(){
            (success, object) -> () in
            DispatchQueue.main.sync {
                if success {
                    self.encyptCardDetails(data: object as! Data)
                }
                else{
                    self.displayAlert(msg: object as! String)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LoadingOverlay.shared.showOverlay(view: self.view)
    }
    
    //MARK:
    //MARK: setupWebView
    
    private func setupWebView(){
        
        //setup webview
        view.addSubview(viewWeb)
        if #available(iOS 11.0, *) {
            viewWeb.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            viewWeb.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            // Fallback on earlier versions
            viewWeb.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            viewWeb.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        
        viewWeb.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        viewWeb.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
//        _ = [viewWeb .setContentCompressionResistancePriority(1000, for: UILayoutConstraintAxis.vertical)]
    }
    
    
    //MARK:
    //MARK: Get RsaKey & encrypt card details
    
    /**
     * In this method we will generate RSA Key from the URL for this we will pass order id and the access code as the request parameter
     * after the successful key generation we'll pass the data to the request handler using complition block
     */
    
    private func gettingRsaKey(completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()){
        
        let serialQueue = DispatchQueue(label: "serialQueue", qos: .userInitiated)
        
        serialQueue.sync {
            self.rsaKeyDataStr = "access_code=\(self.accessCode)&order_id=\(self.orderId)"
            //let requestData = self.rsaKeyDataStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
            
            let requestData = self.rsaKeyDataStr.data(using: String.Encoding.utf8)
            
            guard let urlFromString = URL(string: self.rsaKeyUrl) else{
                return
            }
            var urlRequest = URLRequest(url: urlFromString)
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = requestData
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            print("session",session)
            
            
            session.dataTask(with: urlRequest as URLRequest) {
                (data, response, error) -> Void in
                
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode{
                    
                    guard let data = data else{
                        print("No value for data")
                        completion(false, "Not proper data for RSA Key" as AnyObject?)
                        return
                    }
                    print("data :: ",data)
                    completion(true, data as AnyObject?)
                }
                else{
                    completion(false, "Unable to generate RSA Key please check" as AnyObject?)
                }
                }.resume()
        }
    }
    
    var request: NSMutableURLRequest?
    
    /**
     * encyptCardDetails method we will use the rsa key to encrypt amount and currency and onece the encryption is done we will pass this encrypted data to the initTrans to initiate payment
     */
    
    private func encyptCardDetails(data: Data){
        guard let rsaKeytemp = String(bytes: data, encoding: String.Encoding.ascii) else{
            print("No value for rsaKeyTemp")
            return
        }
        rsaKey = rsaKeytemp
        rsaKey = self.rsaKey.trimmingCharacters(in: CharacterSet.newlines)
        rsaKey =  "-----BEGIN PUBLIC KEY-----\n\(self.rsaKey)\n-----END PUBLIC KEY-----\n"
        print("rsaKey :: ",rsaKey)
        
        let myRequestString = "amount=\(amount)&currency=\(currency)"
        
        let ccTool = CCTool()
        var encVal = ccTool.encryptRSA(myRequestString, key: rsaKey)
        
        encVal = (CFURLCreateStringByAddingPercentEscapes(
            nil,
            encVal as CFString?,
            nil,
            "!*'();:@&=+$,/?%#[]" as CFString,
            CFStringBuiltInEncodings.UTF8.rawValue) as String?)! 
        CCWebViewController.statusCode = 0
        
        //Preparing for webview call
        if CCWebViewController.statusCode == 0{
            let urlAsString = "https://secure.ccavenue.com/transaction/initTrans"
            let encryptedStr = "merchant_id=\(merchantId)&order_id=\(orderId)&redirect_url=\(redirectUrl)&cancel_url=\(cancelUrl)&enc_val=\(encVal ?? "")&access_code=\(accessCode)"
            
            print("encValue :: \(String(describing: encVal) )")
            
            print("encryptedStr :: ",encryptedStr)
            let myRequestData = encryptedStr.data(using: String.Encoding.utf8)
           // request = NSMutableURLRequest(url: URL(string: urlAsString)!)
            
            request  = NSMutableURLRequest(url: URL(string: urlAsString)! as URL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
            request?.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
            request?.setValue(urlAsString, forHTTPHeaderField: "Referer")
            request?.httpMethod = "POST"
            request?.httpBody = myRequestData
            print("\n\n\nwebview :: ",request?.url as Any)
            print("\n\n\nwebview :: ",request?.description as Any)
            print("\n\n\nwebview :: ",request?.httpBody?.description as Any)
            print("\n\n\nwebview :: ",request?.allHTTPHeaderFields! as Any)
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            print("session",session)
            
            session.dataTask(with: request! as URLRequest) {
                (data, response, error) -> Void in
                
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode{
                    
                    guard let data = data else{
                        print("No value for data")
                        return
                    }
                    DispatchQueue.main.async {
                        self.viewWeb.loadRequest(self.request! as URLRequest)
                    }
                    print("data :: ",data)
                }
                else{
                    print("into else")
                    self.displayAlert(msg: "Unable to load webpage currently, Please try again later.")
                }
                }.resume()
            
            print(viewWeb.isLoading)
        }
        else{
            print("Unable to create requestURL")
            displayAlert(msg: "Unable to create requestURL")
        }
    }
    
    func displayAlert(msg: String){
        let alert: UIAlertController = UIAlertController(title: "ERROR", message: msg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            LoadingOverlay.shared.hideOverlayView()
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func encryptRSA(raw: String, key pubKey: String) {
        
    }
    
    
    //MARK:
    //MARK: WebviewDelegate Methods
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("webViewDidStartLoad",webView.request!)
        print(viewWeb.isLoading)
        print(request?.httpBodyStream as Any)
        print(request?.httpBody as Any)
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("Failed to load  webview")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        LoadingOverlay.shared.hideOverlayView()

        //covert the response url to the string and check for that the response url contains the redirect/cancel url if true then chceck for the transaction status and pass the response to the result controller(ie. CCResultViewController)
        let string = (webView.request?.url?.absoluteString)!
        print("String :: \(string)")
        
        if(string.contains(redirectUrl)) //("http://122.182.6.216/merchant/ccavResponseHandler.jsp"))//
        {
            print(viewWeb.isLoading)
            guard let htmlTemp:NSString = webView.stringByEvaluatingJavaScript(from: "document.documentElement.outerHTML") as NSString? else{
                print("failed to evaluate javaScript")
                return
            }
            
            let html = htmlTemp
            print("html :: ",html)
//         var transStatus = "Not Known"
//
//            if ((html ).range(of: "tracking_id").location != NSNotFound) && ((html ).range(of: "bin_country").location != NSNotFound)
//            {
                if ((html ).range(of: "Aborted").location != NSNotFound) || ((html ).range(of: "Cancel").location != NSNotFound) {
                    transStatus = "Transaction Cancelled"
                    
                    if advancePayment == "Ap"
                    {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "CustomerService", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "bookingSuccess") as! BookingSuccess
                        nextViewController.transStatus = transStatus
                        self.present(nextViewController, animated:true, completion:nil)
                    }
                    else if advancePayment == "MW"
                    {
                        self.navToAddMoney(status:"Cancelled")
                    }
                    else
                    {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "CustomerService", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "cCResultViewController") as! CCResultViewController
                        nextViewController.transStatus = transStatus
                        self.present(nextViewController, animated:true, completion:nil)
                    }
                   
                }
                else if ((html ).range(of: "Success").location != NSNotFound) {
                    transStatus = "Transaction Successful"
                    
                    if advancePayment == "Ap"
                    {
                        //self.performSegue(withIdentifier: "bookingPage", sender: self)
                        let storyBoard : UIStoryboard = UIStoryboard(name: "CustomerService", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "bookingSuccess") as! BookingSuccess
                        nextViewController.transStatus = transStatus
                        self.present(nextViewController, animated:true, completion:nil)
                    }
                    else if advancePayment == "MW"
                    {
                       // self.callWebServiceForAddingmoneyToWallet ()
                        self.navToAddMoney (status:"Success")
                    }
                    else
                    {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "CustomerService", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "cCResultViewController") as! CCResultViewController
                        nextViewController.transStatus = transStatus
                        self.present(nextViewController, animated:true, completion:nil)
                    }
                    
                }
                else if ((html ).range(of: "Fail").location != NSNotFound) {
                    transStatus = "Transaction Failed"
                    if advancePayment == "Ap"
                    {
                        //self.performSegue(withIdentifier: "bookingPage", sender: self)
                        let storyBoard : UIStoryboard = UIStoryboard(name: "CustomerService", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "bookingSuccess") as! BookingSuccess
                        nextViewController.transStatus = transStatus
                        self.present(nextViewController, animated:true, completion:nil)
                    }
                    else if advancePayment == "MW"
                    {
                        self.navToAddMoney (status:"Failed")
                    }
                    else
                    {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "CustomerService", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "cCResultViewController") as! CCResultViewController
                        nextViewController.transStatus = transStatus
                        self.present(nextViewController, animated:true, completion:nil)
                    }
                   
                } 
//            }
//            else{
//                print("html does not contain any related data")
//                displayAlert(msg: "html does not contain any related data for this transaction.")
//            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callWebServiceForAddingmoneyToWallet ()
    {
        let parameters = ["user_master_id": strAddMoneyToWallet]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().async
            {
                do
                {
                    try AFWrapper.requestPOSTURL(AFWrapper.PaymentBaseUrl + "ccavenue_app/adding_money_to_wallet.php", params: parameters, headers: nil, success: {
                        (JSONResponse) -> Void in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print(JSONResponse)
                        let json = JSON(JSONResponse)
//                        let msg = json["msg"].stringValue
                        let status = json["status"].stringValue
                        if status == ""
                        {
                            self.navToAddMoney (status:"Success")
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
    
    func navToAddMoney (status:String)
    {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "AdditionalServices", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "wallet") as! Wallet
//        nextViewController.transStatus = status
//        self.navigationController?.pushViewController(nextViewController, animated: true)
//        self.performSegue(withIdentifier: "to_WalletPage", sender: status)
        if status == "Success"
        {
           AlertController.shared.showAlert(targetVC: self, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: "Amount added to Wallet", complition: {
               self.dismiss(animated: true, completion: nil)

           })
        }
        else if status == "Failed"
        {
           AlertController.shared.showAlert(targetVC: self, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: "Amount added to Wallet is Failed", complition: {
               self.dismiss(animated: true, completion: nil)

           })
        }
        else if status == "Cancelled"
        {
           AlertController.shared.showAlert(targetVC: self, title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "appname_text", comment: ""), message: "Amount added to Wallet is Cancelled", complition: {
            self.dismiss(animated: true, completion: nil)

           })
        }
        
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        
        if (segue.identifier == "to_WalletPage")
        {
            let _ = segue.destination as! AddMoneyToWallet
            //let vc = nav.topViewController as!  Wallet
            //vc.transStatus = sender as! String
        }
        else if (segue.identifier == "bookingPage")
        {
            //let nav = segue.destination as! BookingSuccess
            //nav.transStatus = transStatus
        }
     }

}
