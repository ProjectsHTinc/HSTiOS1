//
//  TermsandCondition.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 18/12/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class TermsandCondition: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    var headingText = [String]()
    var descriptionText = [String]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addBackButton()
        headingText = ["Terms of use","Acceptance of Terms","The SkilEx App is owned and operated by Skilex Multiservices Private Limited.","Registration Requirements","User Information","Termination or Suspension","Preservation/Disclosure","Security Components","Usage of Services","What safeguards we have in place to protect your Personal Information?","Indemnification","Force Majeure","If you have any complaint or grievance to report, please write to the Grievance Officer at info@skilex.in"]
        
        descriptionText = ["Skilex Multiservices Private Limited primarily operates, controls and manages the Services (\"as defined below\") provided by it from its corporate office at 30/6, New Damu Nagar, Pappanaickenpalayam, Coimbatore-641037","PLEASE READ THE TERMS OF USE THOROUGHLY AND CAREFULLY. The terms and conditions set forth below (\"Terms of Use\") and the Privacy Policy (\"as defined below\") constitute a legally-binding agreement between SkilEx and you. These Terms of Use contain provisions that define your limits, legal rights and obligations with respect to your use of and participation in (i)the SkilEx mobile application, all content and SkilEx services available through www.Skilex.in (collectively referred to herein as the (\"Application\"), and (ii) the online transactions between those users of the mobile application who are offering services (SkilEx Expert) and those users of the mobile Application who are obtaining services (\"Customer\") through the app. The Terms of Use described below incorporate the Privacy Policy and apply to all users of the app.",
            "When you use any of the Services provided by us such as Electrical, Plumbing, Home cleaning Services, Carpentry etc., you will be subject to the rules, guidelines, policies, terms, and conditions applicable to such service, and they shall be deemed to be incorporated into this Terms of Use and shall be considered as part and parcel of these Terms of Use. As long as you comply with these Terms of Use, we grant you a personal, non-exclusive, non-transferable, limited privilege to enter and use our platforms. In the event of a conflict or inconsistency between any provision of the terms and conditions mentioned herein with those of the particular service, the provisions of the terms and conditions applicable to such specific Services shall prevail.\nThese Terms of Use set forth legally binding terms for your use of our App. By using, visit, accessing our platforms, you agree to be bound by this Terms of Use, whether you are a “Guest” (which means that you simply browse our App) or you are a “Verified Customer” (which means that you have registered with SkilEx as a user). If you do not accept the Terms of Use, you should leave SkilEx App and discontinue use of the Service immediately.\nWe may modify these Terms from time to time, and such modification shall be effective upon its posting on our platforms. You agree to be bound by any modification to this Agreement when you use our SkilEx App after any such modification is posted; it is therefore important that you review the Terms of Use regularly.\nMinors or people below 18 years old are not allowed to use this SkilEx App.",
            "You also agree to provide true, accurate, complete information about yourself while registering on our SkilEx App to avail the Services, you should promptly update and maintain your Registered date to be true and accurate.\nIf you provide any information that is untrue, inaccurate, incomplete, or we have reasonable grounds to suspect that such information is untrue, inaccurate, incomplete, we reserve the right to suspend or terminate your account and refuse any and all current or future use of our SkilEx App (or any portion thereof) at any time. SkilEx will not be liable for any act or omission arising from the inaccurate information provided by you to us.\nYou will be required to enter a valid phone number while registering on SkilEx App as a Verified Customer. By registering your phone number with us, you consent to be contacted by us via phone or SMS notifications, in case of anyservice updates. If we do so, you will be provided the option to \"opt-out\" of receiving future communications. In addition, if at any time you wish not to receive any future communications or you wish to have your name deleted from our mailing lists, please contact us as indicated below. If you are registered with the DND National registry you may not receive any promotional messages from us.","1.SkilEx business model provides you with location based SkilEx Experts. To facilitate this, you hereby authorize SkilEx to use the location based information provided by any of the telecommunication companies when you use the mobile phone to make a booking. The location based information will be used only to facilitate and improve services for you.\n2.If you use the App, you agree that information about your use of the SkilEx App through your mobile device may be communicated to us, and we may obtain information about your mobile device, or your location. By accessing the SKILEX App using a mobile device, you represent that to the extent you import any of your SkilEx data to your mobile device that you have authority to share the transferred data with other access provider. In the event you change or deactivate your mobile account, you must promptly update your SkilEx account information to ensure that your messages are not sent to the person that acquires your old number and failure to do so is your responsibility. You acknowledge that you are responsible for all charges and necessary permissions related to accessing the SKILEX App through your mobile. Therefore, you should check with your provider to find out if our SKILEX App are available and the terms for these services for your specific mobile devices.\n3.SkilEx reserves the right to collect user data including name, contact information and other details to facilitate the Services or use of its SKILEX App to avail Services.\n4.Compilation of user accounts and user accounts bearing contact number and e-mail addresses are owned by SkilEx.\n5.In the case where the system is unable to establish unique identity of the user against a valid mobile number or e-mail address, the account shall be indefinitely suspended. SkilEx reserves the full discretion to suspend a user's account in the above event and does not have the liability to share any account information whatsoever.\n6.We may record your calls to our call centers or to Us.",
            "You agree that SkilEx may at any time terminate your access to the SkilEx restrict or suspend your access to all or any part the App at any time, for any or no reason, with or without prior notice, and without liability.",
            "You acknowledge, consent and agree that SkilEx may access, preserve and disclose your account information and content if required to do so by law or in a good faith belief that such access, preservation or disclosure is reasonably necessary to:\n\nenforce these Terms of Use.\nrespond to your requests for customer service.\nprotect the rights, property or personal safety of SkilEx, its users and the public.",
            "You understand that SkilEx App and software embodied within the SkilEx App may include security components that permit digital materials to be protected, and that use of these materials is subject to usage rules set by SkilEx and/or content providers who provide content to SkilEx.",
            "1.If the service required by you necessitates the entry of SkilEx Expert into your premises, you must ensure the active supervision of the SkilEx Expert. SkilEx will be unable to provide services in the absence of any supervisors appointed by you at the service address.\n2.If you have any questions or complaints regarding the services rendered, you may revert to us within the time specified for the category of services availed. Depending on the category of service availed, SkilEx will provide you with the appropriate recourse to address your concerns.\n3.All invoices and payments due to SkilEx must be cleared immediately upon completion of the task or on the submission of the invoice, whichever is earlier.\n4.You are requested not to solicit the services of the SkilEx Expert. SkilEx will not be responsible for any acts, service quality of the SkilEx Expert if You have engaged the services of such SkilEx Expert without reference to SkilEx.",
            "All payments on the mobile app are secured. This means all Personal Information you provide is transmitted using SSL (Secure Socket Layer) encryption. SSL is a proven coding system that lets your browser automatically encrypt, or scramble, data before you send it to us.",
            "You hereby indemnify to the fullest extent SkilEx from and against any and/or all liabilities, costs, demands, causes of action, damages and expenses arising in any way related to your breach of any of the provisions of these terms.",
            "Without limiting the foregoing, under no circumstances shall SkilEx be held liable for any damage or loss due to deficiency in performance of the SkilEx Service resulting directly or indirectly from acts of nature, forces or causes beyond its reasonable control, including without limitation, Internet failures, computer equipment failures, telecommunication equipment failures, other equipment failures, electrical power failures.",
            ""]
        tableView.estimatedRowHeight = 25.0
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.preferedLanguage()
    }
    
    func preferedLanguage()
    {
        self.navigationItem.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "termsandConditionnavtitle_text", comment: "")
    }
    @objc public override func backButtonClick()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headingText.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TermsandConditionCell
        cell.headingLabel.text = headingText[indexPath.row]
        cell.descripitionLabel.text = descriptionText[indexPath.row]

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
