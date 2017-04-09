//
//  Global.swift
//  Physical_Exam_App
//
//  Created by Yuchen Qian on 3/3/17.
//  Copyright © 2017 YuanHang. All rights reserved.
//

import Foundation
import UIKit

class Global{
    static var myData:[treeNode] = [treeNode]()
    static var recentVisited:[Instruction] = [Instruction]()
    static var favoriteVisited:[Instruction] = [Instruction]()
    static var readList:[Instruction] = [Instruction]()
    static var allList:[Instruction] = [Instruction]()
    static let capacity = 5
    static var recentEdited = false
    static var favoriteEdited = false
    static var readEdited = [0,0,0]
    static var source = 0
}

