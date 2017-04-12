//
//  TableViewCell.swift
//  Physical_Exam_App
//
//  Created by Hang Yuan on 02/04/2017.
//  Copyright © 2017 YuanHang. All rights reserved.
//

import UIKit

//TableViewCell configuration
class TableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var read: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
