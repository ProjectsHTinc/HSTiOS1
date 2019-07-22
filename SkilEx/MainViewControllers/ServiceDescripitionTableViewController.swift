//
//  ServiceDescripitionTableViewController.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 22/07/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit

class ServiceDescripitionTableViewController: UITableViewController {
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var inclusionText: UILabel!
    @IBOutlet weak var exclusionText: UILabel!
    @IBOutlet weak var procedureText: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if LocalizationSystem.sharedInstance.getLanguage() == "en"
        {
            let serviceDetail = UserDefaults.standard.getServicesDescripition()
            self.serviceName.text = serviceDetail?.service_name
            self.amountLabel.text = String(format: "%@ %@","Rs.",(serviceDetail?.rate_card!)!)
            self.inclusionText.text = serviceDetail?.inclusions
            self.exclusionText.text = serviceDetail?.exclusions
            self.procedureText.text = serviceDetail?.service_procedure
        }
        else
        {
            let serviceDetail = UserDefaults.standard.getServicesDescripition()
            self.serviceName.text = serviceDetail?.service_ta_name
            self.amountLabel.text = String(format: "%@ %@","Rs.",(serviceDetail?.rate_card!)!)
            self.inclusionText.text = serviceDetail?.inclusions_ta
            self.exclusionText.text = serviceDetail?.exclusions_ta
            self.procedureText.text = serviceDetail?.service_procedure_ta
        }
       
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    @IBAction func bookNowAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "viewSummary", sender: self)
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "viewSummary"){
            
            let _ = segue.destination as! ViewSummary
        }
    }
    

}
