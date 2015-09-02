//
//  DZDDataStructure.swift
//  ParseStarterProject-Swift
//
//  Created by 竹田 on 2015/9/1.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import Foundation
import UIKit

class DZDDrawableUser {
    var user: DZDUser
    var profileImage: UIImage
    var color: UIColor
    
    init (user: DZDUser) {
        self.user = user
        self.profileImage = UIImage()
        self.color = DZDUtility.getColor()

        DZDDataCenter.fetchProfileImageData(user) { imageData in
            self.profileImage = UIImage(data: imageData)!
        }
    }
}