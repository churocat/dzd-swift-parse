//
//  ChartToChatSegue.swift
//  ParseStarterProject-Swift
//
//  Created by 竹田 on 2015/9/22.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import UIKit

class ChartToChatSegue: UIStoryboardSegue {

    override func perform() {
        // assign the source and destination views to local variables
        var firstVCView = self.sourceViewController.view as UIView!
        var secondVCView = self.destinationViewController.view as UIView!

        // get widths and heights
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
    
        var chartVC = self.sourceViewController as! GroupChartViewController
        var offset = chartVC.memberCollectionView.bounds.height

        // specify the initial position of the destination view
        secondVCView.frame = CGRectMake(0.0, screenHeight - offset, screenWidth, screenHeight)

        // access the app's key window and insert the destination view above the current (source) one
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(secondVCView, aboveSubview: firstVCView)

        // Animate the transition.
        UIView.animateWithDuration(0.8, animations: { () -> Void in
            firstVCView.frame = CGRectOffset(firstVCView.frame, 0.0, -screenHeight + offset)
            secondVCView.frame = CGRectOffset(secondVCView.frame, 0.0, -screenHeight + offset)

            }) { (Finished) -> Void in
                self.sourceViewController.presentViewController(self.destinationViewController as! UIViewController,
                    animated: false,
                    completion: nil)
        }
    }

}
