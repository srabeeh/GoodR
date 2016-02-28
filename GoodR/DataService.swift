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
    
    var REF_FIREBASE: Firebase {
        return _REFBase
    }
}