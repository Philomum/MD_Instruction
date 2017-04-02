//
//  InstructionTableViewController.swift
//  Physical_Exam_App
//
//  Created by Yuchen Qian on 3/2/17.
//  Copyright © 2017 YuanHang. All rights reserved.
//

import UIKit

class InstructionTableViewController: UITableViewController, UISplitViewControllerDelegate {
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var treeList = [treeNode]()
    var stack = [[treeNode]]()
    let data = SectionCdata()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = data.name
        treeList = data.treeNodes
        
        self.splitViewController?.delegate = self
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if(stack.count != 0) {
                    treeList = stack[0]
                    stack.remove(at: 0)
                    tableView.reloadSections([0], with: UITableViewRowAnimation.right)
                }else{
                    performSegue(withIdentifier: "unwindToCollection", sender: self)
                }
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
        return treeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InstructionCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = self.treeList[indexPath.row].insname
        cell.textLabel?.numberOfLines = 3
        cell.accessoryType = .disclosureIndicator
        let myImage = #imageLiteral(resourceName: "c5")
        let imageview:UIImageView=UIImageView(image: myImage)
        imageview.frame = CGRect(x: 20, y: 10, width: 20, height: 20)
        cell.contentView.addSubview(imageview)
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
            vc.titleText = self.treeList[index!].insname
            vc.source = 1
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let tappedIndex = tableView.indexPathForSelectedRow?.row{
            if treeList[tappedIndex].isInstruction == true{
                return true
            }
            else {
                var tempList = [treeNode]()
                tempList.append(contentsOf: treeList[tappedIndex].children)
                stack.append(treeList)
                treeList = tempList
                tableView.reloadSections([0], with: UITableViewRowAnimation.left)
                return false
            }
        }
        else if sender as? UIBarButtonItem == backButton {
            if(stack.count != 0) {
                treeList = stack[0]
                stack.remove(at: 0)
                tableView.reloadSections([0], with: UITableViewRowAnimation.right)
                return false
            }
            else{
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
    
}

extension UITableView {
    func reloadData(with animation: UITableViewRowAnimation) {
        reloadSections(IndexSet(integersIn: 0..<numberOfSections), with: animation)
    }
}
