//
//  Global.swift
//  Physical_Exam_App
//
//  Created by Yuchen Qian on 3/3/17.
//  Copyright © 2017 YuanHang. All rights reserved.
//

import Foundation
import UIKit

//Global variables
class Global{
    
    /**
        - myData: data parsed from website
        - recentVisited: recent visited instructions
        - favoriteVisited: instructions marked as favorite
        - readList: instructions marked as read
        - allList: all instructions
        - capacity: size of recent list
        - source: a tag that keeps track of the current tab bar controller
     */
    
    static var myData:[treeNode] = [treeNode]()
    static var recentVisited:[Instruction] = [Instruction]()
    static var favoriteVisited:[Instruction] = [Instruction]()
    static var readList:[Instruction] = [Instruction]()
    static var allList:[Instruction] = [Instruction]()
    static let capacity = 20
    static var recentEdited = false
    static var favoriteEdited = false
    static var readEdited = [0,0,0]
    static var source = 0
}

