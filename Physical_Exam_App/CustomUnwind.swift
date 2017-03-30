//
//  CustomUnwind.swift
//  Physical_Exam_App
//
//  Created by Hang Yuan on 29/03/2017.
//  Copyright © 2017 YuanHang. All rights reserved.
//

import UIKit

class CustomUnwind: UIStoryboardSegue {
    override func perform() {
        // Assign the source and destination views to local variables.
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
        
        // Animate the transition.
        UIView.animate(withDuration: 0.35,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseInOut,
                       animations: {
                        dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        },
                       completion: { finished in
                        self.source.dismiss(animated: false, completion: nil)
        })
    }
}
