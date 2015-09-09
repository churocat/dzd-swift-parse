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

    func execute() -> BFTask {
        var localQuery = self.copy() as! PFQuery
        localQuery.fromLocalDatastore()
        return localQuery.findObjectsInBackground().continueWithBlock({ (localTask) -> AnyObject! in
            let localResult = localTask.result as! [PFObject]
            if !localResult.isEmpty {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    if Reachability.isConnectedToNetwork() {
                        self.executeFromNetworkAndSaveToLocalDatastore()
                    }
                }
                return localTask
            } else {
                return self.executeFromNetworkAndSaveToLocalDatastore()
            }
        })
    }

    private func executeFromNetworkAndSaveToLocalDatastore() -> BFTask {
        return self.findObjectsInBackground().continueWithSuccessBlock { (cloudTask) -> AnyObject! in
            let cloudResult = cloudTask.result as! [PFObject]
            return PFObject.pinAllInBackground(cloudResult).continueWithSuccessBlock({ (task) -> BFTask! in
                return cloudTask
            })
        }
    }

    func fetchByObjectId(objectId: String) -> BFTask {
        var localQuery = self.copy() as! PFQuery
        localQuery.fromLocalDatastore()
        return localQuery.getObjectInBackgroundWithId(objectId).continueWithBlock({ (localTask) -> AnyObject! in
            if localTask.error == nil {
                let localResult = localTask.result as! PFObject
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    if Reachability.isConnectedToNetwork() {
                        self.fetchByObjectIdFromNetworkAndSaveToLocalDatastore(objectId)
                    }
                }
                return localTask
            } else {
                return self.fetchByObjectIdFromNetworkAndSaveToLocalDatastore(objectId)
            }
        })
    }

    private func fetchByObjectIdFromNetworkAndSaveToLocalDatastore(objectId: String) -> BFTask {
        return self.getObjectInBackgroundWithId(objectId).continueWithSuccessBlock({ (cloudTask) -> AnyObject! in
            let cloudResult = cloudTask.result as! PFObject
            return PFObject.pinAllInBackground([cloudResult]).continueWithSuccessBlock({ (task) -> BFTask! in
                return cloudTask
            })
        })
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
        return query.execute().continueWithSuccessBlock { (task) -> BFTask! in
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
        return query.fetchByObjectId(gameId).continueWithSuccessBlock( { (task) -> BFTask! in
            if let game = task.result as? PFObject {
                let members = game[DZDDB.Game.Members] as! [DZDUser]
                var tasks: [BFTask] = []
                for member in members {
                    if member.objectId != user.objectId {
                        var q = PFUser.query()!
                        tasks += [q.fetchByObjectId(member.objectId!)]
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