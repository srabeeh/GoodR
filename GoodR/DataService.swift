//
//  DataService.swift
//  GoodR
//
//  Created by Sam Rabeeh on 2016-02-27.
//  Copyright © 2016 Sam Rabeeh - RCI. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://goodr.firebaseio.com"

class DataService {
    static let dataService = DataService()
    
    
    private var _REF_Base = Firebase(url: "\(URL_BASE)")
    private var _REF_Users = Firebase(url: "\(URL_BASE)/users")
    private var _REF_Posts = Firebase(url: "\(URL_BASE)/posts")
    
    var REF_BASE: Firebase {
        return _REF_Base
    }
    
    var REF_POSTS: Firebase {
        return _REF_Posts
    }
    
    var REF_USERS: Firebase {
        return _REF_Users
    }
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>){
        REF_USERS.childByAppendingPath(uid).setValue(user)
    }
    
    var REF_USER_CURRENT: Firebase {
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let user = DataService.dataService.REF_USERS.childByAppendingPath(uid)
        return user
    }
}