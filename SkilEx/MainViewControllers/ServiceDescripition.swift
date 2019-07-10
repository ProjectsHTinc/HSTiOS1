//
//  ServiceDescripition.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 10/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class ServiceDescripition: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    var serviceImage = UIImage()
    var exclusions_ta = String()
    var is_advance_payment = String()
    var service_ta_name = String()
    var rate_card_details_ta = String()
    var advance_amount = String()
    var service_procedure = String()
    var inclusions = String()
    var service_name = String()
    var sub_cat_id = String()
    var others = String()
    var exclusions = String()
    var service_procedure_ta = String()
    var rate_card = String()
    var service_id = String()
    var others_ta = String()
    var inclusions_ta = String()
    var rate_card_details = String()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if indexPath.row == 1
//        {
//             let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//
//             return cell
//        }
//
//        if indexPath.row == 2
//        {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//
//            return cell
//        }
//
//        if indexPath.row == 3
//        {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//
//            return cell
//        }
//
//        if indexPath.row == 4
//        {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//
//            return cell
//        }
        
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
