//
//  InstructionViewController.swift
//  Physical_Exam_App
//
//  Created by Yuchen Qian on 3/2/17.
//  Copyright © 2017 YuanHang. All rights reserved.
//

import UIKit

class InstructionViewController: UIViewController {

    @IBOutlet weak var instructionText: UITextView!
    
    var titleText : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.instructionText.text = titleText
        addToRecent()
        
        //RecentViewController.addViewedList(item: Instruction(name: titleText))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addToRecent(){
        let newInstruction = Instruction(name: titleText)
        for i in 0..<Recent.recentVisited.count{
            if newInstruction.name == Recent.recentVisited[i].name{
                Recent.recentVisited.remove(at: i)
                break
            }
        }
        if Recent.recentVisited.count == Recent.capacity{
            Recent.recentVisited.remove(at: Recent.capacity - 1)
        }
        Recent.recentVisited.insert(newInstruction, at: 0)
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
