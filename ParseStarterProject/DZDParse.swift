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

extension BFTask {
    convenience init(DZDErrorInfo: String, DZDErrorCode: Int) {
        self.init(error: NSError(domain: "DZD", code: DZDErrorCode, userInfo: ["error" : DZDErrorInfo]))
    }
    convenience init(DZDErrorInfo: String) {
        self.init(DZDErrorInfo: DZDErrorInfo, DZDErrorCode: 5566)
    }
}

class DZDParseUtility {
    static func checkResultArrayNotZero(result: AnyObject!) -> [PFObject]? {
        if let result = result as? [PFObject] {
            return result.count > 0 ? result : nil
        } else {
            return nil
        }
    }
}

class DZDDataCenter {
  
    // NOT support one user in multiple game
    // return the first game's id
    static func fetchGameId(user: DZDUser) -> BFTask! {
        let query = PFQuery(className: DZDDB.TabelGame)
        query.whereKey(DZDDB.Game.Members, equalTo: user)
        query.includeKey(DZDDB.Game.Members)
        return query.findObjectsInBackground().continueWithSuccessBlock { (task) -> BFTask! in
            if let games = DZDParseUtility.checkResultArrayNotZero(task.result) {
                return BFTask(result: games[0].objectId)
            } else {
                return BFTask(DZDErrorInfo: "result is an empty array or not an array")
            }
        }
    }
    
    // NOT support one user in multiple game
    // return the first game's id
    static func fetchGameOtherMembers(gameId: String, user: DZDUser) -> BFTask! {
        let query = PFQuery(className: DZDDB.TabelGame)
        return query.getObjectInBackgroundWithId(gameId).continueWithSuccessBlock( { (task) -> BFTask! in
            if let game = task.result as? PFObject {
                let members = game[DZDDB.Game.Members] as! [DZDUser]
                var tasks: [BFTask] = []
                for member in members {
                    if member.objectId != user.objectId {
                        tasks += [member.fetchIfNeededInBackground()]
                    }
                }
                return BFTask(forCompletionOfAllTasksWithResults: tasks)
            } else {
                return BFTask(DZDErrorInfo: "didn't found a game with id: \(gameId)")
            }
        })
    }
    
    static func fetchProfileImageData(user: DZDUser) -> BFTask! {
        let userImageFile = user[DZDDB.User.Image] as! PFFile
        return userImageFile.getDataInBackground()
    }
}