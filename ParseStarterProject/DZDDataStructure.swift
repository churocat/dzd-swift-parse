//
//  DZDDataStructure.swift
//  ParseStarterProject-Swift
//
//  Created by 竹田 on 2015/9/1.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import Foundation
import UIKit
import Bolts


class DZDDrawableUser {
    var user: DZDUser
    var profileImage: UIImage
    var color: UIColor
    
    init (user: DZDUser) {
        self.user = user
        self.profileImage = UIImage()
        self.color = DZDUtility.getColor()
    }
    
    func fetchProfileImage() -> BFTask! {
        return DZDDataCenter.fetchProfileImageData(user).continueWithSuccessBlock({ (task) -> AnyObject! in
            let imageData = task.result as! NSData
            self.profileImage = UIImage(data: imageData)!
            return nil
        })
    }
}

extension UIActivityIndicatorView {
    func startAnimatingAndBeginIgnoringUI() {
        self.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }

    func stopAnimatingAndEndIgnoringUI() {
        self.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
}

extension UIImage {
    func isZeroSize() -> Bool {
        return self.size == CGSize.zeroSize
    }
}