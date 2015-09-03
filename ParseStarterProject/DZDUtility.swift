//
//  DZDCommons.swift
//  ParseStarterProject-Swift
//
//  Created by 竹田 on 2015/9/1.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import Foundation
import UIKit

class DZDUtility {
    static func showAlert(var message: String?, title: String = "Oops!", controller: UIViewController) {
        if message == nil {
            message = "Please try again!"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        var actionOk = UIAlertAction(title: "Ok", style: .Default) { (action) -> Void in
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(actionOk)
        
        controller.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    static var colorCount = 0
    static func getColor() -> UIColor {
        var allColors = [
            UIColor(R: 0, G: 103, B: 166),
            UIColor(R: 242, G: 87, B: 45),
            UIColor(R: 245, G: 197, B: 100),
            UIColor(R: 0, G: 137, B: 144),
            UIColor(R: 0, G: 171, B: 216),
        ]
        return allColors[(++colorCount % allColors.count)]
    }
}


extension UIColor {
    convenience init(R: CGFloat, G: CGFloat, B: CGFloat) {
        self.init(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: 1.0)
    }
}