//
//  DataService.swift
//  GoodR
//
//  Created by Sam Rabeeh on 2016-02-27.
//  Copyright © 2016 Sam Rabeeh - RCI. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let dataService = DataService()
    
    private var _REFBase = Firebase(url: "https://goodr.firebaseio.com")
    private var _REFUsers = Firebase(url: "https://goodr.firebaseio.com/users")
    private var _REFPosts = Firebase(url: "https://goodr.firebaseio.com/posts")
    
    var REF_FIREBASE: Firebase {
        return _REFBase
    }
    
    var REF_FIREBASE_POSTS: Firebase {
        return _REFPosts
    }
    
    var REF_FIREBASE_USERS: Firebase {
        return _REFUsers
    }
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>){
        REF_FIREBASE_USERS.childByAppendingPath(uid).setValue(user)
    }
}