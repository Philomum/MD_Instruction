//
//  InstructionViewController.swift
//  Physical_Exam_App
//
//  Created by Yuchen Qian on 3/2/17.
//  Copyright © 2017 YuanHang. All rights reserved.
//

import UIKit


class InstructionViewController: UIViewController,UIWebViewDelegate {
    
    
    var isFavorite = false
    var source = 1
    //hard coded url
    var urlString:String="https://youtu.be/xyJSBu6fFRk?list=PL8tZP77vSdwv9YlYNXJhNNTSuxqWR5qUQ"
    
    
    @IBOutlet weak var YoutubeView: UIWebView!
    @IBOutlet weak var rightButton: UIBarButtonItem!
    
    @IBAction func marked(_ sender: Any) {
        isFavorite = !isFavorite
        if isFavorite == true{
            rightButton.image = #imageLiteral(resourceName: "star2")
            let newInstruction = Instruction(name: titleText)
            Global.favoriteVisited.append(newInstruction)
        }
        else{
            rightButton.image = #imageLiteral(resourceName: "star1")
            for i in 0..<Global.favoriteVisited.count{
                if titleText == Global.favoriteVisited[i].name{
                    Global.favoriteVisited.remove(at: i)
                    break
                }
            }
        }
        let _ = Instruction.saveFavorite(Global.favoriteVisited)
        Global.favoriteEdited = true
    }
   
    private var _orientations = UIInterfaceOrientationMask.portrait
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        get { return self._orientations }
        set { self._orientations = newValue }
    }


    @IBOutlet weak var instructionText: UITextView!
    
    var titleText : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addToRecent()
        YoutubeView.delegate=self
        YoutubeView.loadRequest(URLRequest(url: URL(string:urlString)!))
        YoutubeView.scrollView.scrollsToTop=true
        YoutubeView.frame=view.bounds
        // Do any additional setup after loading the view.
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        for i in 0..<Global.favoriteVisited.count{
            if titleText == nil {
                continue;
            }
            if Global.favoriteVisited[i].name == titleText{
                rightButton.image = #imageLiteral(resourceName: "star2")
                isFavorite = true
                break
            }
        }
        //RecentViewController.addViewedList(item: Instruction(name: titleText))
    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if source == 1{
                    performSegue(withIdentifier: "unwindToTable", sender: self)
                }
                else if source == 3{
                    performSegue(withIdentifier: "unwindToFavorite", sender: self)
                }
                else if source == 2{
                    performSegue(withIdentifier: "unwindToRecent", sender: self)
                }
                else{
                    performSegue(withIdentifier: "unwindToAll", sender: self)
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
    

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Layout subviews manually
        
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        print("return")
        textField.resignFirstResponder()
        return true;
    }
    
    
    func addToRecent(){
        if(titleText == nil){
            return
        }
        let newInstruction = Instruction(name: titleText)
        for i in 0..<Global.recentVisited.count{
            if newInstruction.name == Global.recentVisited[i].name{
                Global.recentVisited.remove(at: i)
                break
            }
        }
        if Global.recentVisited.count == Global.capacity{
            Global.recentVisited.remove(at: Global.capacity - 1)
        }
        Global.recentVisited.insert(newInstruction, at: 0)
        let _ = Instruction.saveRecent(Global.recentVisited)
        Global.recentEdited = true
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
