//
//  FavoriteTableViewController.swift
//  Physical_Exam_App
//
//  Created by Hang Yuan on 22/02/2017.
//  Copyright © 2017 YuanHang. All rights reserved.
//

import UIKit

class FavoriteTableViewController: UITableViewController,UISearchBarDelegate, UISplitViewControllerDelegate  {

    var Favorite_List = [Instruction]()
    var searchActive : Bool = false
    var filtered = [Instruction]()
    @IBOutlet weak var searchBar: UISearchBar!
    let colors = [0xba87d4,0x9eb5f0,0xf0b971,0xff87a7,0x7aebeb,0xb3de78]
    let images = [#imageLiteral(resourceName: "t1"),#imageLiteral(resourceName: "t2"),#imageLiteral(resourceName: "t3"),#imageLiteral(resourceName: "t4"),#imageLiteral(resourceName: "t5"),#imageLiteral(resourceName: "t6")]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        Favorite_List = Global.favoriteVisited
        self.tableView.rowHeight = 100
        self.splitViewController?.delegate = self
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
        //self.tableView.contentOffset.y = self.searchBar.frame.size.height
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Favorite_List = Global.favoriteVisited
        self.tableView.reloadData()
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
        if searchActive == false{
            return Favorite_List.count
        }
        else{
            return filtered.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "InstructionCell", for: indexPath) as! TableViewCell
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        // Configure the cell...
        
        if searchActive == false{
            cell.label.text = self.Favorite_List[indexPath.row].name
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
        let result = shouldPerformSegue(withIdentifier: "FavoriteToDetail", sender: self)
        if result == true {
            self.performSegue(withIdentifier: "FavoriteToDetail", sender: self)
        }
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        var isRead = false
        var text = ""
        if self.searchActive == false{
            text = self.Favorite_List[editActionsForRowAt.row].name
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
                    Global.readList.append(self.Favorite_List[editActionsForRowAt.row])
                }
                else{
                    Global.readList.append(self.filtered[editActionsForRowAt.row])
                }
                let _ = Instruction.saveRead(Global.readList)
                self.tableView.reloadData()
            }
            let delete = UITableViewRowAction(style: .destructive, title: "delete") { action, indexPath in
                Global.favoriteVisited.remove(at: indexPath.row)
                self.Favorite_List = Global.favoriteVisited
                self.tableView.reloadData()
                let _ = Instruction.saveRecent(Global.favoriteVisited)
                
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
                self.tableView.reloadData()
            }
            let delete = UITableViewRowAction(style: .destructive, title: "delete") { action, indexPath in
                Global.favoriteVisited.remove(at: indexPath.row)
                self.Favorite_List = Global.favoriteVisited
                self.tableView.reloadData()
                let _ = Instruction.saveRecent(Global.favoriteVisited)
                
            }
            return [read, delete]
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
        filtered = Favorite_List.filter({ (text) -> Bool in
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
        
        if segue.identifier == "FavoriteToDetail" {
            let index = self.tableView.indexPathForSelectedRow?.row
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers[0] as! InstructionViewController
            if searchActive == false{
                vc.titleText = self.Favorite_List[index!].name
            }
            else{
                vc.titleText = self.filtered[index!].name
            }
            vc.source = 3
        }
    }
    
    @IBAction func unwindToFavorite(segue: UIStoryboardSegue) {
        print("unwind from detail")
    }
    
    @IBAction func clear(_ sender: Any) {
        Global.favoriteVisited = [Instruction]()
        Favorite_List = [Instruction]()
        tableView.reloadData()
        let _ = Instruction.saveRecent(Global.favoriteVisited)
    }

}
