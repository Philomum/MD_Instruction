//
//  parseData.swift
//  Physical_Exam_App
//
//  Created by Yuchen Qian on 4/6/17.
//  Copyright © 2017 YuanHang. All rights reserved.
//

import Foundation

let str1 = "C.Respiratory/Inspection/Posterior and Anterior lung fields with deep breaths (verbalize inspection)"
let str2 = "C.Respiratory/Posterior : palpate, percuss, auscultate/Correct Technique: cross arms, hands on shoulder to raise scapulae"
let str3 = "C.Respiratory/Posterior : palpate, percuss, auscultate/Check respiratory (thoracic) expansion"
let list = [str1, str2, str3]

var treeList = [treeNode]()


func createTreeNode(array: [String], index: Int) -> treeNode{
    let node = treeNode(name: array[index])
    if index + 1 == array.count {
        node.isInstruction = true
        node.childInstruction = createInstructionNode(array: array, index: index)
    }
    else {
        node.children.append(createTreeNode(array: array, index: index + 1))
    }
    
    return node
}

func createInstructionNode(array: [String], index: Int) -> Instruction {
    let ins = Instruction(name: array[index])
    return ins
}

func parse() {
    for str in list {
        var arr = str.components(separatedBy: "/")
        var tempNode: treeNode
        tempNode = treeNode(name: arr[0])
        treeList.append(tempNode)
        tempNode.children.append(createTreeNode(array: arr, index: 1))
    }
    
    for treeNode in treeList {
        for child in treeNode.children {
            for children in child.children {
                if children.isInstruction == true {
                    print((children.childInstruction?.name)! as String)
                }
            }
        }
    }
}

