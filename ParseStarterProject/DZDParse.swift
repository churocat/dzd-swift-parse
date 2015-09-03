//
//  DZDParse.swift
//  ParseStarterProject-Swift
//
//  Created by 竹田 on 2015/9/1.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import Foundation
import Parse

typealias DZDUser = PFUser
//class DZDUser : PFUser {

//}

extension PFQuery {
    
    func executeAsync(block: PFArrayResultBlock?) {
        self.findObjectsInBackgroundWithBlock(block)

    }
    
    func execute() -> [AnyObject]? {
        return self.findObjects()
    }
    
    func fetchByObjectIdAsync(objectId: String, block: PFObjectResultBlock?){
        self.getObjectInBackgroundWithId(objectId, block: block)
    }
    
    func fetchByObjectId(objectId: String) -> PFObject? {
        return self.getObjectWithId(objectId)
    }
}

class DZDDataCenter {
    
    static func fetchGroupId(username: String, handler: (String? -> Void)) {
        let query = PFQuery(className: DZDDB.TabelParticipate)
        query.whereKey(DZDDB.Participate.Username, equalTo: username)
        query.executeAsync { (objects, error) -> Void in
            if let objects = objects as? [PFObject] {
                if objects.count > 0 {
                    handler(objects[0][DZDDB.Participate.GroupId]! as? String)
                }
            }
        }
    }
    
    // NOT support one user in multiple game
    // return the first game's id
    static func fetchGameId(user: DZDUser, handler: (String? -> Void)) {
        let query = PFQuery(className: DZDDB.TabelGame)
        query.whereKey(DZDDB.Game.Members, equalTo: user)
        query.includeKey(DZDDB.Game.Members)
        query.executeAsync { (objects, error) -> Void in
            if let objects = objects as? [PFObject] {
                if objects.count > 0 {
                    handler(objects[0].objectId)
                }
            }
        }
    }
    
    // NOT support one user in multiple game
    // return the first game's id
    static func fetchGameOtherMembers(gameId: String, user: DZDUser, handler: ([DZDUser]? -> Void)) {
        let query = PFQuery(className: DZDDB.TabelGame)
        query.fetchByObjectIdAsync(gameId, block: { (object, error) -> Void in
            if let game = object {
                if let members = game[DZDDB.Game.Members] as? [DZDUser] {
                    var otherMembers: [DZDUser] = []
                    for member in members {
                        if member.objectId == user.objectId {
                            continue
                        }
                        
                        let query = DZDUser.query()!
                        query.fetchByObjectIdAsync(member.objectId!) { object in
                            otherMembers += [member]
                            // finish all query
                            if otherMembers.count == members.count - 1 {
                                handler(otherMembers)
                            }
                        }
                    }
                }
            }
        })
    }
    
    static func fetchProfileImageData(user: DZDUser, handler: (NSData -> Void)) {
        let userImageFile = user[DZDDB.User.Image] as! PFFile
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    handler(imageData)
                }
            }
        }
    }
}