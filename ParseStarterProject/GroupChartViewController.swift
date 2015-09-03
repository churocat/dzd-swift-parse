/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class GroupChartViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Outlet
    
    @IBOutlet weak var memberCollectionView: UICollectionView!
    
    // MARK: - Property
    
    let currentDrawableUser = DZDDrawableUser(user: DZDUser.currentUser()!)
    
    var otherDrawableMembers: [DZDDrawableUser] = [] {
        didSet {
            println("ohh")
            memberCollectionView.reloadData()
        }
    }
    
    var allDrawableMembers: [DZDDrawableUser] { return [currentDrawableUser] + otherDrawableMembers }
    
    // MARK: - Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshMembers()
    }
    
    func refreshMembers() {
        
        currentDrawableUser.fetchProfileImage {}
        
        DZDDataCenter.fetchGameId(currentDrawableUser.user) { gameId in
            if let gameId = gameId {
                println("gameId: \(gameId)")
                
                DZDDataCenter.fetchGameOtherMembers(gameId, user: self.currentDrawableUser.user) { members in
                    if let members = members {
                        let drawableMembers = members.map { DZDDrawableUser(user: $0) }
                        
                        var count = 0
                        for drawableMember in drawableMembers {
                            drawableMember.fetchProfileImage {
                                if ++count == drawableMembers.count {
                                    self.otherDrawableMembers = drawableMembers
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    

    // MARK: - UICollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allDrawableMembers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memberCell", forIndexPath: indexPath) as! MemberCollectionViewCell
        
        cell.profileImage.image = allDrawableMembers[indexPath.row].profileImage
        cell.profileImage.lineColor = allDrawableMembers[indexPath.row].color

        return cell
    }
}
