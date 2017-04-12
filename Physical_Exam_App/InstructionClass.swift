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
    static let sourceK = "source"
}

//class Instruction is used to save instruction and its correspoinding url
class Instruction:NSObject,NSCoding{
    var name = ""
    var source = ""

    //urls for different files
    static let DocumentsDirectory1 = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURLforRecent = DocumentsDirectory1.appendingPathComponent("RecentFile")
    static let DocumentsDirectory2 = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURLforFavorite = DocumentsDirectory2.appendingPathComponent("FavoriteFile")
    static let DocumentsDirectory3 = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURLforRead = DocumentsDirectory3.appendingPathComponent("ReadFile")

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
    
    // MARK: - Save and Load Recent
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
    
    // MARK: - Save and Load Favorite
    static func saveFavorite(_ Favorite_List: [Instruction]) -> Bool{
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(Favorite_List, toFile: Instruction.ArchiveURLforFavorite.path)
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
    
    // MARK: - Save and Load Read
    static func saveRead(_ Read_List: [Instruction]) -> Bool{
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(Read_List, toFile: Instruction.ArchiveURLforRead.path)
        if !isSuccessfulSave{
            print("Failed to save info")
            return false
        }
        else {
            return true
        }
    }
    
    static func loadFromReadFile() -> [Instruction]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Instruction.ArchiveURLforRead.path) as? [Instruction]
    }

}
