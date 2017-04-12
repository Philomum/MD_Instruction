//
//  CustomSegue.swift
//  Physical_Exam_App
//
//  Created by Hang Yuan on 26/03/2017.
//  Copyright © 2017 YuanHang. All rights reserved.
//

import UIKit

class CustomSegue: UIStoryboardSegue {
    override func perform()
    {
        let modelName = UIDevice.current.modelName
        if modelName.contains("iPad") || modelName.contains("Simulator"){
            let src = self.source
            let dst = self.destination
            src.showDetailViewController(dst, sender: self)
        }
        else{
            let src = self.source
            let dst = self.destination
            
            src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
            dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
            
            UIView.animate(withDuration: 0.35,
                           delay: 0.0,
                           options: UIViewAnimationOptions.curveEaseInOut,
                           animations: {
                            dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
            },
                           completion: { finished in
                            src.present(dst, animated: false, completion: nil)
            }
            )

        }

    }
}
