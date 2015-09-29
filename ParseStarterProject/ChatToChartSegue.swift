//
//  ChatToChartSegue.swift
//  ParseStarterProject-Swift
//
//  Created by 竹田 on 2015/9/22.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import UIKit

class ChatToChartSegue: UIStoryboardSegue
{
    override func perform() {
        // assign the source and destination views to local variables
        var secondVCView = self.sourceViewController.view as UIView!
        var firstVCView = self.destinationViewController.view as UIView!

        // get heights
        let screenHeight = UIScreen.mainScreen().bounds.size.height

        var chartVC = self.destinationViewController as! GroupChartViewController
        var offset = chartVC.memberCollectionView.bounds.height

        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(firstVCView, aboveSubview: secondVCView)

        // animate the transition
        UIView.animateWithDuration(0.8, animations: { () -> Void in
            firstVCView.frame = CGRectOffset(firstVCView.frame, 0.0, screenHeight - offset)
            secondVCView.frame = CGRectOffset(secondVCView.frame, 0.0, screenHeight - offset)

            }) { (Finished) -> Void in

                self.sourceViewController.dismissViewControllerAnimated(false, completion: nil)
        }
    }
}
