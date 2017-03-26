//
//  InstructionTableViewController.swift
//  Physical_Exam_App
//
//  Created by Yuchen Qian on 3/2/17.
//  Copyright © 2017 YuanHang. All rights reserved.
//

import UIKit

class InstructionTableViewController: UITableViewController, UISplitViewControllerDelegate {
    
    //    var InstructionList = [
    //        "Examiner washes hands before starting examination (soap or foam)",
    //        "Palpate radial pulse rate (at least 15 seconds) and assess regularity (verbalize both)",
    //        "Observe respiratory rate and pattern (verbalize inspection)",
    //        "BP correct technique: bares arm for accuracy",
    //        "BP correct technique: palpate brachial pulse apply cuff snugly, bladder over brachial artery",
    //        "BP correct technique: cuff edge 1 inch above antecubital crease",
    //        "BP correct technique: arm and cuff resting at heart level",
    //        "Demonstrate how to assess systolic blood pressure by palpation",
    //        "Inflate cuff to 30 mm Hg above palpable systole",
    //        "Release cuff pressure by 2 mm Hg/heart beat or 1 mm Hg/sec (slow & steady)",
    //        "Blood pressure reading verbalized to patient",
    //        "Postural (orthostatic) Hypotension - changes in BP and pulse with postural change from supine to upright.  Measure blood pressure sitting then after standing for 3 minutes."
    //    ]
    
    var InstructionList = [String]()
    
    var instDic = [String: Any]()
    var instList = [String]()
    var listTitle: String = "Instruction List"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.splitViewController?.delegate = self
        
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
        
        instDic = parseJson(section: "secA")
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        //print(instDic)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                performSegue(withIdentifier: "unwindToCollection", sender: self)
            default:
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToTableView(segue: UIStoryboardSegue) {
        print("unwind to tableview controller")
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
        cell.textLabel?.numberOfLines = 3
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80;
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
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let tappedIndex = tableView.indexPathForSelectedRow?.row{
            if tappedIndex == 0{
                InstructionList.remove(at: 0)
                tableView.reloadSections([0], with: UITableViewRowAnimation.left)
                return false
            }
            else {
                return true
            }
        }
        return true
    }
    
    
    // MARK: - Split View Controller
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    // MARK: - Parse Json
    
    func parseJson(section: String) -> [String: Any]{
        var InstructionDic = [String: Any]()
        do {
            if let file = Bundle.main.url(forResource: section, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // parse here
                    InstructionDic = object
                    //print(object)
                    if let myTitle = object["name"] as? String {
                        //print(myTitle)
                        self.title = myTitle
                    }
                    if let mySections = object["sections"] as? NSArray {
                        if let myDict = mySections[0] as? NSDictionary {
                            //                            print(myDict["general"] as! NSArray)
                            //                            print(myDict["Special-Screening-Techniques"] as! NSArray)
                            if let general = myDict["general"] as? NSArray {
                                for item in general {
                                    let a = item as! NSDictionary
                                    let inst = a["name"] as! String
                                    InstructionList.append(inst)
                                }
                            }
                            if let special = myDict["Special-Screening-Techniques"] as? NSArray {
                                for item in special {
                                    let a = item as! NSDictionary
                                    let inst = a["name"] as! String
                                    InstructionList.append(inst)
                                }
                            }
                        }
                    }
                }
                else{
                    print("Invalid Json File!")
                }
            }
            else{
                print("File does not exits!")
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return InstructionDic
    }
    
    // Generate Class here
    func parseInstruction(instructionDict: [String: Any]) -> treeNode {
        let myNode = treeNode()
        
        return myNode
        
    }
    
    
}

extension UITableView {
    func reloadData(with animation: UITableViewRowAnimation) {
        reloadSections(IndexSet(integersIn: 0..<numberOfSections), with: animation)
    }
}
