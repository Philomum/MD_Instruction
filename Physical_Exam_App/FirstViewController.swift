//
//  FirstViewController.swift
//  Physical_Exam_App
//
//  Created by Hang Yuan on 21/02/2017.
//  Copyright © 2017 YuanHang. All rights reserved.
//

import UIKit
import CoreGraphics

class FirstViewController: UICollectionViewController {
    
    
    let reuseIdentifier = "SectionCell"
    var sections = ["A.Vital Signs","B.Head","C.Respiratory", "D.Cardiovascular","E: Abdomen","F.Lymph","G.Neurological","H.Breast","K.Musculoskeletal"]
    var images = [#imageLiteral(resourceName: "c1"),#imageLiteral(resourceName: "c2"),#imageLiteral(resourceName: "c3"),#imageLiteral(resourceName: "c4"),#imageLiteral(resourceName: "c5"),#imageLiteral(resourceName: "c6"),#imageLiteral(resourceName: "c7"),#imageLiteral(resourceName: "c8"),#imageLiteral(resourceName: "c9")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Recent.recentVisited = Instruction.loadFromRecentFile() ?? []
        Favorite.favoriteVisited = Instruction.loadFromFavoriteFile() ?? []
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
        cell.myLabel.textAlignment = .center
        let imageview:UIImageView=UIImageView(image:images[indexPath.item])
        imageview.frame = CGRect(x: 20, y: 10, width: 120, height: 120)
        cell.contentView.addSubview(imageview)
        //cell.backgroundColor = UIColor.cyan
        return cell
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

