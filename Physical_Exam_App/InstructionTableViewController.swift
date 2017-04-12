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
    
    var myTitle: String = ""
    var treeList = [treeNode]()
    var stack = [[treeNode]]()
    let colors = [0xba87d4,0x9eb5f0,0xf0b971,0xff87a7,0x7aebeb,0xb3de78]
    let images = [#imageLiteral(resourceName: "t1"),#imageLiteral(resourceName: "t2"),#imageLiteral(resourceName: "t3"),#imageLiteral(resourceName: "t4"),#imageLiteral(resourceName: "t5"),#imageLiteral(resourceName: "t6")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Will be 9 tree nodes initially, modifiy
        self.title = myTitle
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
    
    func traverse(node:treeNode){
        for i in 0..<node.children.count{
            if node.children[i].isInstruction == true{
                Global.allList.append(node.children[i].childInstruction!)
            }
            else{
                traverse(node: node.children[i])
            }
        }
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
        //let cell = tableView.dequeueReusableCell(withIdentifier: "InstructionCell", for: indexPath) as! TableViewCell
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        // Configure the cell...
        
        cell.label.text = self.treeList[indexPath.row].insname
        cell.label.textColor = UIColor.white
        cell.label.numberOfLines = 3
        //cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = UIColor(rgb:colors[indexPath.row%6])
        cell.pic.image = images[indexPath.item%6]
        
        for i in 0..<Global.readList.count{
            if cell.label.text == Global.readList[i].name{
                cell.read.text = "Read"
                break
            }
        }
        cell.read.textColor = UIColor.white
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100;
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        if treeList[editActionsForRowAt.row].isInstruction == false{
            return []
        }
        else{
            let text = self.treeList[editActionsForRowAt.row].insname
            var isRead = false
            for i in 0..<Global.readList.count{
                if text == Global.readList[i].name{
                    isRead = true
                }
            }
            if isRead == false{
                let read = UITableViewRowAction(style: .normal, title: "Mark as \n read") { action, indexPath in
                    Global.readList.append(self.treeList[editActionsForRowAt.row].childInstruction!)
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                    let _ = Instruction.saveRead(Global.readList)
                    for i in 0..<Global.recentVisited.count{
                        if text == Global.recentVisited[i].name{
                            Global.readEdited[0] = 1
                        }
                    }
                    for i in 0..<Global.favoriteVisited.count{
                        if text == Global.favoriteVisited[i].name{
                            Global.readEdited[1] = 1
                        }
                    }
                    Global.readEdited[2] = 1
                }
                return [read]
            }
            else{
                let read = UITableViewRowAction(style: .normal, title: "Mark as \n unread") { action, indexPath in
                    for i in 0..<Global.readList.count{
                        if text == Global.readList[i].name{
                            Global.readList.remove(at: i)
                            let _ = Instruction.saveRead(Global.readList)
                            break
                        }
                    }
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                    for i in 0..<Global.recentVisited.count{
                        if text == Global.recentVisited[i].name{
                            Global.readEdited[0] = 1
                        }
                    }
                    for i in 0..<Global.favoriteVisited.count{
                        if text == Global.favoriteVisited[i].name{
                            Global.readEdited[1] = 1
                        }
                    }
                    Global.readEdited[2] = 1
                }
                return [read]
            }
        }
       
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // choose one animation you want
        
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.5, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
        
//        This animation below is stupid
        //cell.alpha = 0
        //let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
        //cell.layer.transform = transform
        //UIView.animate(withDuration: 1.0, animations: {
        //    cell.alpha = 1
        //    cell.layer.transform = CATransform3DIdentity
        //})
    }
    
    
    


    
    //override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
    
    //}
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
            vc.urlString = self.treeList[index!].childInstruction!.source
            vc.preWidth = self.view.bounds.width
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
            print("here")
            if(stack.count != 0) {
                print("backback")
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = shouldPerformSegue(withIdentifier: "ShowDetail", sender: self)
        if result == true {
            self.performSegue(withIdentifier: "ShowDetail", sender: self)
        }
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

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
