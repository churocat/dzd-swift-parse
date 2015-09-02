//
//  ProfileImageView.swift
//  ParseStarterProject-Swift
//
//  Created by 竹田 on 2015/9/1.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import UIKit

class ProfileImageView: UIImageView {

    var lineColor: UIColor = UIColor.blackColor() {
        didSet {
            self.layer.borderColor = lineColor.CGColor
            setNeedsDisplay()
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.frame.size.width / 2;
        self.clipsToBounds = true
        self.layer.borderWidth = 3.0;
    }

}
