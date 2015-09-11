//
//  AddItemViewController.swift
//  ParseStarterProject-Swift
//
//  Created by 竹田 on 2015/9/9.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController
{

    @IBOutlet weak var weightTextLabel: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBAction func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func done() {
        let weight = (weightTextLabel.text! as NSString).doubleValue
        let date = datePicker.date

        if weight == 0 {
            DZDUtility.showAlert("Input your weight!", controller: self)
            return
        }

        DZDDataCenter.saveWeight(weight, date: date).continueWithBlock { (task) -> AnyObject! in
            dispatch_async(dispatch_get_main_queue()) {
                if task.error == nil {
                    DZDUtility.showAlert("Save successfully!", title: "Yeah!", controller: self) {
                        DZDDataCenter.getWeights().continueWithSuccessBlock({ (task) -> AnyObject! in
                            println("weights = \(task.result)")
                            return nil
                        })
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                } else {
                    if task.error.code == DZDError.DuplicateValue {
                        DZDUtility.showConfirm("當天已有資料，是否覆蓋呢？", controller: self) {
                            DZDDataCenter.saveWeightForced(weight, date: date)
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                    } else {
                        DZDUtility.showAlert("Save failed :'(", controller: self)
                    }
                }
            }
            return nil
        }
    }

}
