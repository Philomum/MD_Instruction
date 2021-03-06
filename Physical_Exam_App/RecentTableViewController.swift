//
//  RecentTableViewController.swift
//  Physical_Exam_App
//
//  Created by Hang Yuan on 22/02/2017.
//  Copyright © 2017 YuanHang. All rights reserved.
//

import UIKit

class RecentTableViewController: UITableViewController,UISearchBarDelegate, UISplitViewControllerDelegate {

    var Recent_List = [Instruction]()
    var filtered = [Instruction]()
    var searchActive : Bool = false
    @IBOutlet weak var searchBar: UISearchBar!
    let colors = [0xba87d4,0x9eb5f0,0xf0b971,0xff87a7,0x7aebeb,0xb3de78]
    let images = [#imageLiteral(resourceName: "t1"),#imageLiteral(resourceName: "t2"),#imageLiteral(resourceName: "t3"),#imageLiteral(resourceName: "t4"),#imageLiteral(resourceName: "t5"),#imageLiteral(resourceName: "t6")]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        Recent_List = Global.recentVisited
        self.tableView.rowHeight = 100
        self.splitViewController?.delegate = self
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
        Global.source = 2

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Global.recentEdited == true || Global.readEdited[0] == 1{
            Recent_List = Global.recentVisited
            self.tableView.reloadData()
            Global.recentEdited = false
            Global.readEdited[0] = 0
        }
        Global.source = 2
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
        if searchActive == true{
            return filtered.count
        }
        return Recent_List.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        // Configure the cell...
        if searchActive == false{
            cell.label.text = self.Recent_List[indexPath.row].name
        }
        else{
            cell.label.text = self.filtered[indexPath.row].name
        }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = shouldPerformSegue(withIdentifier: "RecentToDetail", sender: self)
        if result == true {
            self.performSegue(withIdentifier: "RecentToDetail", sender: self)
        }
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        var isRead = false
        var text = ""
        if self.searchActive == false{
            text = self.Recent_List[editActionsForRowAt.row].name
        }
        else{
            text = self.filtered[editActionsForRowAt.row].name
        }

        for i in 0..<Global.readList.count{
            if text == Global.readList[i].name{
                isRead = true
                break
            }
        }
        if isRead == false{
            let read = UITableViewRowAction(style: .normal, title: "Mark as \n read") { action, indexPath in
                if self.searchActive == false{
                    Global.readList.append(self.Recent_List[editActionsForRowAt.row])
                }
                else{
                    Global.readList.append(self.filtered[editActionsForRowAt.row])
                }
                let _ = Instruction.saveRead(Global.readList)
                self.tableView.reloadRows(at: [indexPath], with: .none)
                Global.readEdited[2] = 1
                for i in 0..<Global.favoriteVisited.count{
                    if text == Global.favoriteVisited[i].name{
                        Global.readEdited[1] = 1
                    }
                }
            }
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, indexPath in
                if self.searchActive == true{
                    let name = (self.filtered)[indexPath.row].name
                    let index = self.checkIndex(name: name)
                    self.filtered.remove(at: indexPath.row)
                    Global.recentVisited.remove(at: index)
                    
                }
                else{
                    Global.recentVisited.remove(at: indexPath.row)
                }
                self.Recent_List = Global.recentVisited
                self.tableView.reloadData()
                let _ = Instruction.saveRecent(Global.recentVisited)
            }
            return [read, delete]
        }
        else{
            let read = UITableViewRowAction(style: .normal, title: "Mark as \n unread") { action, indexPath in
                for i in 0..<Global.readList.count{
                    if text == Global.readList[i].name{
                        Global.readList.remove(at: i)
                        break
                    }
                }
                let _ = Instruction.saveRead(Global.readList)
                self.tableView.reloadRows(at: [indexPath], with: .none)
                Global.readEdited[2] = 1
                for i in 0..<Global.favoriteVisited.count{
                    if text == Global.favoriteVisited[i].name{
                        Global.readEdited[1] = 1
                    }
                }
            }
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, indexPath in
                if self.searchActive == true{
                    let name = (self.filtered)[indexPath.row].name
                    self.filtered.remove(at: indexPath.row)
                    let index = self.checkIndex(name: name)
                    Global.recentVisited.remove(at: index)
                    
                }
                else{
                    Global.recentVisited.remove(at: indexPath.row)
                }
                self.Recent_List = Global.recentVisited
                self.tableView.reloadData()
                let _ = Instruction.saveRecent(Global.recentVisited)
            }
            return [read, delete]
        }
    }
    
    /**
        Find out the index of selected item in recent list
     
        - Parameter name: name of the item in filtered list.
     
        - Returns: The corresponding Index in recent List
     */
    func checkIndex(name: String) -> Int {
        for i in 0..<Global.recentVisited.count {
            if (Global.recentVisited)[i].name == name {
                return i;
            }
        }
        return -1;
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // choose one animation you want
        if searchActive == false {
            cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
            UIView.animate(withDuration: 0.5, animations: {
                cell.layer.transform = CATransform3DMakeScale(1,1,1)
            })
        }
    }
    
    // MARK: - Search Bar Functions
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        if filtered.count != 0{
            searchActive = true
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = Recent_List.filter({ (text) -> Bool in
            let tmp: NSString = text.name as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        
        if searchText != ""{
            searchActive = true
        }
        else {
            searchActive = false
        }
        if filtered.count != 0{
            searchActive = true
        }
        self.tableView.reloadData()
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


    
    // MARK: - Split View Controller
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        return true
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "RecentToDetail" {
            let index = self.tableView.indexPathForSelectedRow?.row
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! InstructionViewController
            if searchActive == false{
                vc.titleText = self.Recent_List[index!].name
                vc.urlString = self.Recent_List[index!].source
            }
            else{
                vc.titleText = self.filtered[index!].name
                vc.urlString = self.filtered[index!].source
            }
            vc.preWidth = self.view.bounds.width
        }
    }
    @IBAction func unwindToRecent(segue: UIStoryboardSegue) {
    
    }

    /**
        Clear all history when trash can button is tapped
     
        - Parameter sender: action sender.
     */
    @IBAction func clearHistory(_ sender: Any) {
        let alertController = UIAlertController(title: "Are you sure ?", message: "Clear ALL the History", preferredStyle: UIAlertControllerStyle.alert)
        
        let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
        })
        alertController.addAction(noAction)
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: {(alert :UIAlertAction!) in
            Global.recentVisited = [Instruction]()
            self.Recent_List = Global.recentVisited
            self.tableView.reloadData()
            let _ = Instruction.saveRecent(Global.recentVisited)
            Global.recentEdited = true
        })
        alertController.addAction(yesAction)
        present(alertController, animated: true, completion: nil)
    }
}

