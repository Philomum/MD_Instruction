//
//  InstructionTableViewController.swift
//  Physical_Exam_App
//
//  Created by Yuchen Qian on 3/2/17.
//  Copyright © 2017 YuanHang. All rights reserved.
//

import UIKit

class InstructionTableViewController: UITableViewController, UISplitViewControllerDelegate {

    var InstructionList = [
        "Examiner washes hands before starting examination (soap or foam)",
        "Palpate radial pulse rate (at least 15 seconds) and assess regularity (verbalize both)",
        "Observe respiratory rate and pattern (verbalize inspection)",
        "BP correct technique: bares arm for accuracy",
        "BP correct technique: palpate brachial pulse apply cuff snugly, bladder over brachial artery",
        "BP correct technique: cuff edge 1 inch above antecubital crease",
        "BP correct technique: arm and cuff resting at heart level",
        "Demonstrate how to assess systolic blood pressure by palpation",
        "Inflate cuff to 30 mm Hg above palpable systole",
        "Release cuff pressure by 2 mm Hg/heart beat or 1 mm Hg/sec (slow & steady)",
        "Blood pressure reading verbalized to patient",
        "Postural (orthostatic) Hypotension - changes in BP and pulse with postural change from supine to upright.  Measure blood pressure sitting then after standing for 3 minutes."
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.splitViewController?.delegate = self
        
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return InstructionList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InstructionCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.InstructionList[indexPath.row]

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowDetail" {
            let index = self.tableView.indexPathForSelectedRow?.row
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! InstructionViewController
            vc.titleText = self.InstructionList[index!]
            let newInstruction = Instruction(name: vc.titleText)
            Recent.recentVisited.append(newInstruction)
        }
    }
    

    
    
    // MARK: - Split View Controller
//    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
//        return true
//    }
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    

}
