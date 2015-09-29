//
//  ChatViewController.swift
//  ParseStarterProject-Swift
//
//  Created by 竹田 on 2015/9/15.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController
{

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func swipeDown(sender: AnyObject) {
        self.performSegueWithIdentifier("chatToChartSegue", sender: self)
    }

}
