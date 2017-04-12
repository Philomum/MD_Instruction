//
//  FirstViewController.swift
//  Physical_Exam_App
//
//  Created by Hang Yuan on 21/02/2017.
//  Copyright © 2017 YuanHang. All rights reserved.
//

import UIKit
import CoreGraphics

class FirstViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout{
    
    
    let reuseIdentifier = "SectionCell"
    var sections = ["Vital Signs","Head","Respiratory", "Cardiovascular","Abdomen","Lymph","Neurological","Breast","Musculoskeletal"]
    var images = [#imageLiteral(resourceName: "c1"),#imageLiteral(resourceName: "c2"),#imageLiteral(resourceName: "c3"),#imageLiteral(resourceName: "c4"),#imageLiteral(resourceName: "c5"),#imageLiteral(resourceName: "c6"),#imageLiteral(resourceName: "c7"),#imageLiteral(resourceName: "c8"),#imageLiteral(resourceName: "c9")]
    let modelName = UIDevice.current.modelName
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Parse your data here
        Global.recentVisited = Instruction.loadFromRecentFile() ?? []
        Global.favoriteVisited = Instruction.loadFromFavoriteFile() ?? []
        Global.readList = Instruction.loadFromReadFile() ?? []
        //self.view.addSubview(collectionView)
        // Do any additional setup after loading the view, typically from a nib.
        //let nib = UINib(nibName: "SectionCollectionViewCell", bundle: nil)
        //self.collectionView.register(nib, forCellWithReuseIdentifier: "SectionCell")
        //print(modelName)
        Global.source = 1
        clean()
    }
    
    func clean(){
        
        var exist = false
        var temp = [Instruction]()
        for i in 0..<Global.readList.count{
            exist = false
            var index = 0
            for j in 0..<Global.allList.count{
                if Global.allList[j].name == Global.readList[i].name{
                    exist = true
                    index = j
                }
            }
            if exist == true{
                temp.append(Global.allList[index])
            }
        }
        Global.readList = temp
        
        temp = [Instruction]()
        for i in 0..<Global.recentVisited.count{
            exist = false
            var index = 0
            for j in 0..<Global.allList.count{
                if Global.allList[j].name == Global.recentVisited[i].name{
                    exist = true
                    index = j
                }
            }
            if exist == true{
                temp.append(Global.allList[index])
            }
        }
        Global.recentVisited = temp
        
        temp = [Instruction]()
        for i in 0..<Global.favoriteVisited.count{
            exist = false
            var index = 0
            for j in 0..<Global.allList.count{
                if Global.allList[j].name == Global.favoriteVisited[i].name{
                    exist = true
                    index = j
                }
            }
            if exist == true{
                temp.append(Global.allList[index])
            }
        }
        Global.favoriteVisited = temp
        
        let _ = Instruction.saveRecent(Global.recentVisited)
        let _ = Instruction.saveRead(Global.readList)
        let _ = Instruction.saveFavorite(Global.favoriteVisited)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Global.source = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SectionCollectionViewCell
        //cell.myLabel.text = self.items[indexPath.item]
        cell.myLabel.text = self.sections[indexPath.item]
        cell.myLabel.textAlignment = .center
        //cell.myLabel.textColor = UIColor(rgb: 0x1ba685)
        cell.pic.image=images[indexPath.item]
        //cell.pic.frame = CGRect(x: 10, y: 10, width: cell.frame.width-30, height: cell.frame.width-30)
        //cell.backgroundColor = UIColor.cyan
        cell.myLabel.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    
    
    override open var shouldAutorotate: Bool {
        return true
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Compute the dimension of a cell for an NxN layout with space S between
        // cells.  Take the collection view's width, subtract (N-1)*S points for
        // the spaces between the cells, and then divide by N to find the final
        // dimension for the cell's width and height.
        
        var cellsAcross: CGFloat = 0
        if modelName.contains("iPad") || modelName.contains("Simulator"){
            cellsAcross = 4
        }
        else{
            cellsAcross = 3
        }
        let spaceBetweenCells: CGFloat = 10
        let dim = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
        return CGSize(width: dim, height: dim+10)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowList" {
            let svc = segue.destination as! UISplitViewController
            let nvc = svc.viewControllers[0] as! UINavigationController
            let vc = nvc.viewControllers[0] as! InstructionTableViewController
            let cell = sender as! UICollectionViewCell
            let indexPath = self.collectionView!.indexPath(for: cell)
            let index = (indexPath?.row)!
            // switch case
            if index == 2 {
                vc.myTitle = (Global.myData)[0].insname
                vc.treeList = (Global.myData)[0].children
            }
            
        }
    }
    

    
    /*
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }*/
    
    @IBAction func unwindToCollectionView(segue: UIStoryboardSegue) {
        print("unwind from tableview controller")
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected cell #\(self.sections[indexPath.item])")
    }
    
    
}

