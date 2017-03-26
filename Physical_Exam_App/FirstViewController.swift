//
//  FirstViewController.swift
//  Physical_Exam_App
//
//  Created by Hang Yuan on 21/02/2017.
//  Copyright © 2017 YuanHang. All rights reserved.
//

import UIKit

class FirstViewController: UICollectionViewController {
    
    
    let reuseIdentifier = "SectionCell"
    var sections = ["A.Vital Signs","B.Head","C.Respiratory", "D.Cardiovascular","E: Abdomen","F.Lymph","G.Neurological","H.Breast","K.Musculoskeletal"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Recent.recentVisited = Instruction.loadFromFile() ?? []
        //self.view.addSubview(collectionView)
        // Do any additional setup after loading the view, typically from a nib.
        //let nib = UINib(nibName: "SectionCollectionViewCell", bundle: nil)
        //self.collectionView.register(nib, forCellWithReuseIdentifier: "SectionCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(sections.count)
        return sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SectionCollectionViewCell
        //cell.myLabel.text = self.items[indexPath.item]
        cell.myLabel.text = self.sections[indexPath.item]
        //cell.backgroundColor = UIColor.cyan
        return cell
    }
    
    @IBAction func unwindToCollectionView(segue: UIStoryboardSegue) {
        print("unwind from tableview controller")
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected cell #\(self.sections[indexPath.item])")
    }
    
    
}

