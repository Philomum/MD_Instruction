//
//  SectionCdata.swift
//  Physical_Exam_App
//
//  Created by Yuchen Qian on 3/29/17.
//  Copyright © 2017 YuanHang. All rights reserved.
//

import Foundation

class SectionCdata {
    
    var treeNodes = [treeNode]()
    var name = "Respriatory"
    
    init() {
        generateTreeNodes()
    }
    
    func generateTreeNodes() {
        let n1 = createTreeNode(name: "Inspection")
        n1.children.append(createInsNode(name: "Correct Technique: cross arms, hands on shoulder to raise scapulae"))
        n1.children.append(createInsNode(name: "Check respiratory (thoracic) expansion"))
        n1.children.append(createInsNode(name: "Tactile Fremitus -'boy' include lateral lung fields here"))
        n1.children.append(createInsNode(name: "Percuss posterior lung fields (bilaterally and symmetrically)"))
        n1.children.append(createInsNode(name: "Auscultate posterior lung fields (bilaterally and symmetrically)"))
        n1.children.append(createInsNode(name: "Correct Technique: full breath per position for auscultation"))
        n1.children.append(createInsNode(name: "Correct Technique: instruct patient to breathe through an open mouth"))
        n1.children.append(createInsNode(name: "Auscultate 'boy' and 'e' to 'a' changes"))
        treeNodes.append(n1)
        
        let n2 = createTreeNode(name: "Lateral: percuss, auscultate")
        n2.children.append(createInsNode(name: "Percuss lateral lung fields (bilaterally)"))
        n2.children.append(createInsNode(name: "Auscultate lateral lung fields (bilaterally)"))
        treeNodes.append(n2)
        
        let n3 = createTreeNode(name: "Anterior: Palpate, percuss, auscultate")
        n3.children.append(createInsNode(name: "Tactile Fremitus - 'boy'"))
        n3.children.append(createInsNode(name: "Percuss anterior lung fields (bilaterally and symmetrically)"))
        n3.children.append(createInsNode(name: "Auscultate anterior lung fields (bilaterally and symmetrically)"))
        n3.children.append(createInsNode(name: "Auscultate apices in supraclavicular fossae with the bell of the stethoscope"))
        treeNodes.append(n3)
    }
    
    func createTreeNode(name: String) -> treeNode {
        let node = treeNode(name: name)
        node.isInstruction = false
        return node
    }
    
    func createInsNode(name: String) -> treeNode {
        let node = treeNode(name: name)
        node.isInstruction = true
        node.childInstruction = Instruction(name: name)
        return node
    }
}
