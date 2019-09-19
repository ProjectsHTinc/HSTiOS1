//
//  AboutUs.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 17/08/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class AboutUs: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var aboutLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addBackButton()
        self.preferedLanguage()

    }
    
    @objc public override func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.preferedLanguage()

    }
    
    func preferedLanguage()
    {
        self.navigationItem.title =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "aboutusnavtitle_text", comment: "")
        self.aboutLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "aboutLabel_text", comment: "")
        if LocalizationSystem.sharedInstance.getLanguage() == "en"
        {
            self.textView.text = "SkilEx is an Indian tech start up that offers a one-stop solution to connect people, who are in need of household services like plumbing, electrical works, repairs/fixes and personal services like beauty care, personalized fitness training, with those who provide them. When there is need of service whether it’s personal or local, there is always a void in reaching service experts at any given time. SkilEx comes into this scene of desperation to help consumers get the required service done at the right time. One can access a range of local services like refurbishment, renovation, restoration etc.; and personal services like fitness training, massages, physiotherapy, counselling, etc., via SkilEx and get things done in a convenient and affordable way.\n\nInitially aimed at launching in major cities of South India, SkilEx’s vision is to expand its base across the country including all the cities, building a bond between service providers and their customers."

        }
        else
        {
            self.textView.text = "ஸ்கில்எக்ஸ், வீட்டு சேவைகள் (பிளம்பிங், மின்னியல் சேவை, வீட்டு சாதன பராமரிப்பு முதலியன..) மற்றும் தனிப்பயனாக்கப்பட்ட சேவைகள் (ஒப்பனை, அழகு பராமரிப்பு மற்றும் உடற்பயிற்சி சேவை முதலியன...) ஆகியவற்றை தேவைப்படுவோர் அச்சேவை வழங்குநரை தொடர்பு கொண்டு பயன்பெற இந்தியாவில் உருவாக்கப்பட்ட ஆன்லைன் வாடிக்கையாளர் சேவை தளம் ஆகும். வாடிக்கையாளர்களுக்கு தேவைப்படும் சேவைகளை தரமாகவும், மலிவாகவும், தேவைப்படும் நேரத்திற்கு வழங்கவும் ஸ்கில்எக்ஸ் வழிவகை செய்கிறது.\n\nஆரம்ப நிலையில் ஸ்கில்எக்ஸ் தென்னிந்தியாவின் முக்கிய நகரங்களில் துவங்கினாலும் மக்களின் தேவையை கணக்கில் கொண்டு, பின் வரும் நாட்களில் நாடு முழுவதும் தன் சேவையை வழங்க திட்டமிட்டுள்ளது."
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
