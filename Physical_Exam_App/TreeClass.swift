//
//  TreeClass.swift
//  Physical_Exam_App
//
//  Created by Hang Yuan on 21/02/2017.
//  Copyright © 2017 YuanHang. All rights reserved.
//

import Foundation
import UIKit

//treeNode class is used as the node in the instruction tree
class treeNode {
    
    /**
        - isInstruction: is this item an instruction.
        - children: the children of this current treenode.
        - childInstruction: its instruction if it is an instruction.
        - insname: name of this node
     */
    
    var isInstruction = false
    var children = [treeNode]()
    var childInstruction: Instruction? = nil
    var insname = ""
    
    init() {
        
    }
    
    init(name: String) {
        self.insname = name
    }
}
