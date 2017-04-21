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
    let modelName = UIDevice.current.modelName
    var item:DispatchWorkItem!
    //hard coded url
    var urlString:String="www.youtube.com"
    var preWidth:CGFloat = 0
    var titleText : String!
    
    
    @IBOutlet weak var leftButton4: UIBarButtonItem!
    @IBOutlet weak var leftButton3: UIBarButtonItem!
    @IBOutlet weak var leftButton2: UIBarButtonItem!
    @IBOutlet weak var leftButton: UIBarButtonItem!
    @IBOutlet weak var YoutubeView: UIWebView!
    @IBOutlet weak var rightButton: UIBarButtonItem!
    

    /**
        Mark as favorite function when favorite button is tapped
     
        - Parameter sender: action sender
     */
    @IBAction func marked(_ sender: Any) {
        isFavorite = !isFavorite
        if isFavorite == true{
            rightButton.image = #imageLiteral(resourceName: "star2")
            let newInstruction = Instruction(name: titleText)
            newInstruction.source = urlString
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
   
    // MARK: - Interface orientation
    
    private var _orientations = UIInterfaceOrientationMask.portrait
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        get { return self._orientations }
        set { self._orientations = newValue }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addToRecent()
        YoutubeView.delegate=self
        item = DispatchWorkItem( qos: .utility, flags: .detached) {
            print("running first task")
            self.YoutubeView.loadRequest(URLRequest(url: URL(string:self.urlString)!))
        }
        item.perform()
        YoutubeView.scrollView.scrollsToTop=true
        
        //set the size of the instruction view
        if modelName.contains("iPad") && modelName.contains("Simulator"){
            YoutubeView.frame = CGRect(x: 0, y: 0, width: view.bounds.width-preWidth, height: view.bounds.height)
        }
        else{
            YoutubeView.frame = self.view.bounds
        }
        // Do any additional setup after loading the view.
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        //configure the favorite button
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
        
        

        
        //hide the back button in iPad
        if modelName.contains("iPad") || modelName.contains("Simulator"){
            if self.tabBarController?.selectedIndex == nil{
                leftButton.title = ""
                //leftButton.isEnabled = false
            }
            else if self.tabBarController!.selectedIndex == 1{
                leftButton2.title = ""
                //leftButton2.isEnabled = false
            }
            else if self.tabBarController!.selectedIndex == 2{
                leftButton3.title = ""
                //leftButton3.isEnabled = false
            }
            else if self.tabBarController!.selectedIndex == 3{
                leftButton4.title = ""
                //leftButton4.isEnabled = false
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(Global.source)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.modalPresentationCapturesStatusBarAppearance = true;
    }
    
    // unwind with swipe gesture
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if Global.source == 1{
                    performSegue(withIdentifier: "unwindToTable", sender: self)
                }
                else if Global.source == 3{
                    performSegue(withIdentifier: "unwindToFavorite", sender: self)
                }
                else if Global.source == 2{
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
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        item.cancel()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        YoutubeView.frame = self.view.bounds
        // Layout subviews manually
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        print("return")
        textField.resignFirstResponder()
        return true;
    }
    
    /**
        Add the instruction to recent list
     
        - Parameter sender: action sender
     */
    func addToRecent(){
        if(titleText == nil){
            return
        }
        let newInstruction = Instruction(name: titleText)
        newInstruction.source = urlString
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
    
    
    
    override var prefersStatusBarHidden: Bool{
        return false
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
