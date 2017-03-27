//
//  InstructionClass.swift
//  Physical_Exam_App
//
//  Created by Hang Yuan on 21/02/2017.
//  Copyright © 2017 YuanHang. All rights reserved.
//

import Foundation
import UIKit

struct InstructionKey{
    static let nameK = "name"
    static let isVedioK = "isVedio"
    static let sourceK = "source"
    static let detailK = "detail"
    static let checkedK = "checked"
}


class Instruction:NSObject,NSCoding{
    var name = ""
    var isVedio = true
    var source = ""
    var detail = ""
    var checked = false
    
    static let DocumentsDirectory1 = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURLforRecent = DocumentsDirectory1.appendingPathComponent("RecentFile")
    static let DocumentsDirectory2 = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURLforFavorite = DocumentsDirectory2.appendingPathComponent("FavoriteFile")

    init(name: String){
        self.name = name
    }
    
    // MARK: - Encode Instruction class
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name,forKey: InstructionKey.nameK)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        let name = aDecoder.decodeObject(forKey: InstructionKey.nameK) as! String
        self.init(name:name)
    }
    
    static func saveRecent(_ Recent_List: [Instruction]) -> Bool{
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(Recent_List, toFile: Instruction.ArchiveURLforRecent.path)
        if !isSuccessfulSave{
            print("Failed to save info")
            return false
        }
        else {
            return true
        }

    }
    
    static func loadFromRecentFile() -> [Instruction]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Instruction.ArchiveURLforRecent.path) as? [Instruction]
    }
    
    static func saveFavorite(_ Recent_List: [Instruction]) -> Bool{
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(Recent_List, toFile: Instruction.ArchiveURLforFavorite.path)
        if !isSuccessfulSave{
            print("Failed to save info")
            return false
        }
        else {
            return true
        }
    }
    
    static func loadFromFavoriteFile() -> [Instruction]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Instruction.ArchiveURLforFavorite.path) as? [Instruction]
    }
}
