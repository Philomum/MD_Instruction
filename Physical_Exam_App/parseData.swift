//
//  parseData.swift
//  Physical_Exam_App
//
//  Created by Yuchen Qian on 4/6/17.
//  Copyright © 2017 YuanHang. All rights reserved.
//

import Foundation

var list = [String]()

// Check if the parent node list contains current node
func containsNode(treeNodeList: [treeNode], currNode: treeNode) -> (Bool, Int) {
    if(treeNodeList.count == 0) {
        return (false, -1)
    }
    for i in 0...treeNodeList.count - 1 {
        if treeNodeList[i].insname == currNode.insname {
            return (true, i)
        }
    }
    return (false, -1)
}

// Create Instruction Node
func createInstructionNode(array: [String], index: Int, url: String) -> Instruction {
    let ins = Instruction(name: array[index])
    ins.source = url
    return ins
}

// Append a treeNode to its parent's children list
func appendNode(parentNode: treeNode, array: [String], index: Int, url: String) {
    var node = treeNode(name: array[index])
    let(result, ind) = containsNode(treeNodeList: parentNode.children, currNode: node)
    if result == true {
        node = parentNode.children[ind]
    }
    else{
        parentNode.children.append(node)
    }
    
    if index + 1 == array.count {
        node.isInstruction = true
        node.childInstruction = createInstructionNode(array: array, index: index, url: url)
    }
    else {
        appendNode(parentNode: node, array: array, index: index + 1, url: url)
    }

}

// Parse Data Here
func parse() -> [treeNode]{
    var treeList = [treeNode]()
    //let source = URL(string: "https://users.cs.duke.edu/~hy/ece_590/sources.txt")!
//    let sessionConfig = URLSessionConfiguration.default
//    let session = URLSession(configuration: sessionConfig)
//    let request = URLRequest(url: source)
//    let task = session.downloadTask(with: request)
    
    if let source = URL(string: "https://users.cs.duke.edu/~hy/ece_590/sources.txt") {
        do {
            let contents = try String(contentsOf: source)
            list = contents.components(separatedBy: "\n")
        } catch {
            print("Failed loading contents. Stop parsing")
            //return
        }
    } else {
        print("Bad url. Stop parsing")
        //return
    }
    
    for i in 0...list.count - 1 {
        if i >= list.count {
            break
        }
        while i < list.count && list[i] == "" {
            list.remove(at: i)
        }
    }

    for str in list {
        // choose your separate symbol
        var myLine = str.components(separatedBy: ";")
        var dataArr = myLine[0].components(separatedBy: "/")
        let url = myLine[1]

        var tempNode = treeNode(name: dataArr[0])
        let(result, index) = containsNode(treeNodeList: treeList, currNode: tempNode)
        if result == false {
            treeList.append(tempNode)
        }
        else{
            tempNode = treeList[index]
        }
        appendNode(parentNode: tempNode, array: dataArr, index: 1, url: url)
    }
    
    // Play around and check correctness
//    for node in treeList {
//        for child in node.children {
//            print(child.insname)
//            for children in child.children{
//                if children.isInstruction {
//                    //print(children.childInstruction?.name)
//                    //print(children.childInstruction?.source)
//                }
//            }
//        }
//    }
    return treeList
    
}


