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
    static func showAlert(var message: String?, title: String = "Oops!", controller: UIViewController, okCompletion: (()->Void)? = nil) {
        if message == nil {
            message = "Please try again!"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        var actionOk = UIAlertAction(title: "Ok", style: .Default) { (action) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
            if let okCompletion = okCompletion {
                okCompletion()
            }
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

// MARK: - extension

extension UIColor {
    convenience init(R: CGFloat, G: CGFloat, B: CGFloat) {
        self.init(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: 1.0)
    }
}


public class Reachability
{
    static func isConnectedToNetwork() -> Bool {
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0

        var response: NSURLResponse?
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil) as NSData?

        var status = false
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                status = true
            }
        }
        return status
    }
}

extension NSDate {
    var unixtimeString: String {
        let timestampWithDummy = self.timeIntervalSince1970.description
        let tokens = timestampWithDummy.componentsSeparatedByString(".")
        return tokens[0] ?? "0"
    }
}