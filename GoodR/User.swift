//
//  User.swift
//  GoodR
//
//  Created by Sam Rabeeh on 2016-03-05.
//  Copyright © 2016 Sam Rabeeh - RCI. All rights reserved.
//

import Foundation
import Firebase

class User {
    private var _userName: String!
    
    private var _UserRef: Firebase!
    
    var ProfileUserName: String! {
        return _userName
    }
    
    var UserRef: Firebase {
        return _UserRef
    }
    
    init (profileName: String!) {
        self._userName = profileName
        self._UserRef = DataService.dataService.REF_FIREBASE_USERS.childByAppendingPath("users")
    }

}
