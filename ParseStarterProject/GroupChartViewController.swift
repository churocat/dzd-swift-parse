/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Bolts

class GroupChartViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Outlet
    
    @IBOutlet weak var memberCollectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!    
    @IBOutlet weak var tempTextView: UITextView!

    // MARK: - Property
    
    let currentDrawableUser = DZDDrawableUser(user: DZDUser.currentUser()!)
    var otherDrawableMembers: [DZDDrawableUser] = [] {
        didSet {
            let tasks: [BFTask] = allDrawableMembers.map{ $0.fetchProfileImage() }
            BFTask(forCompletionOfAllTasks: tasks).continueWithSuccessBlock({ (task) -> AnyObject! in
                dispatch_async(dispatch_get_main_queue()) {
                    self.memberCollectionView.reloadData()
                    self.spinner.stopAnimatingAndEndIgnoringUI()
                }
                return nil
            })
        }
    }
    var allDrawableMembers: [DZDDrawableUser] { return [currentDrawableUser] + otherDrawableMembers }
    
    // MARK: - Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshMembers()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        DZDDataCenter.getWeights().continueWithSuccessBlock { (task) -> AnyObject! in
            if let weights = task.result as? [DZDWeight] {
                dispatch_async(dispatch_get_main_queue()) {
                    self.tempTextView.text = "\(weights)"
                }
            }
            return nil
        }
    }

    func refreshMembers() {
        spinner.startAnimatingAndBeginIgnoringUI()
        
        DZDDataCenter.fetchGameId(currentDrawableUser.user).continueWithSuccessBlock({ (task) -> BFTask! in
            let gameId = task.result as! String
            return DZDDataCenter.fetchGameOtherMembers(gameId, user: self.currentDrawableUser.user)
        }).continueWithSuccessBlock({ (task) -> AnyObject! in
            let members = task.result as!  [DZDUser]
            self.otherDrawableMembers = members.map { return DZDDrawableUser(user: $0) }
            return nil
        })
    }

    // MARK: - UICollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allDrawableMembers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memberCell", forIndexPath: indexPath) as! MemberCollectionViewCell
        
        let profileImage = allDrawableMembers[indexPath.row].profileImage
        cell.profileImage.image = profileImage
        cell.profileImage.lineColor = profileImage.isZeroSize() ? UIColor.clearColor() : allDrawableMembers[indexPath.row].color

        return cell
    }
}
