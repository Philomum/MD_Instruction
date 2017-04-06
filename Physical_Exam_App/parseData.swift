//
//  parseData.swift
//  Physical_Exam_App
//
//  Created by Yuchen Qian on 4/6/17.
//  Copyright © 2017 YuanHang. All rights reserved.
//

import Foundation

let str1 = "C.Respiratory/Inspection/Posterior and Anterior lung fields with deep breaths (verbalize inspection);https://www.youtube.com/watch?v=-EWLR4Xox_4&feature=youtu.be&app=desktop"
let str2 = "C.Respiratory/Posterior : palpate, percuss, auscultate/Correct Technique: cross arms, hands on shoulder to raise scapulae;https://www.youtube.com/watch?v=-EWLR4Xox_4&feature=youtu.be&app=desktop"
let str3 = "C.Respiratory/Posterior : palpate, percuss, auscultate/Check respiratory (thoracic) expansion;https://www.youtube.com/watch?v=-EWLR4Xox_4&feature=youtu.be&app=desktop"
let list = [str1, str2, str3]

var treeList = [treeNode]()


func createTreeNode(array: [String], index: Int, url: String) -> treeNode{
    let node = treeNode(name: array[index])
    if index + 1 == array.count {
        node.isInstruction = true
        node.childInstruction = createInstructionNode(array: array, index: index, url: url)
    }
    else {
        node.children.append(createTreeNode(array: array, index: index + 1, url: url))
    }
    
    return node
}

func createInstructionNode(array: [String], index: Int, url: String) -> Instruction {
    let ins = Instruction(name: array[index])
    ins.source = url
    return ins
}

func parse () {
    for str in list {
        // choose your separate symbol
        var array = str.components(separatedBy: ";")
        var arr = array[0].components(separatedBy: "/")
        let url = array[1]
        //print(arr)
        var tempNode: treeNode
        tempNode = treeNode(name: arr[0])
        treeList.append(tempNode)
        tempNode.children.append(createTreeNode(array: arr, index: 1, url: url))
    }
    
    for treeNode in treeList {
        for child in treeNode.children {
            for children in child.children {
                if children.isInstruction == true {
                    print((children.childInstruction?.source)! as String)
                }
            }
        }
    }
}

