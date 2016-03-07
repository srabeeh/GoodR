//
//  Post.swift
//  GoodR
//
//  Created by Sam Rabeeh on 2016-03-02.
//  Copyright © 2016 Sam Rabeeh - RCI. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    private var _postDesc: String!
    private var _imageUrl: String?
    private var _likes: Int!
    private var _authKey: String!
    private var _postKey: String!
    private var _postTimeStamp: NSDate!
    
    private var _postRef: Firebase!
    
    var postKey: String {
        return _postKey
    }
    
    var authorKey: String {
        return _authKey
    }
    
    var postRef: Firebase {
        return _postRef
    }
    
    var postDescription: String{
        return _postDesc
    }
    
    var imageUrl: String! {
        return _imageUrl
    }
    
    var likes: Int! {
        return _likes
    }
    
    var timeStamp: NSDate! {
        return _postTimeStamp
    }
    
    init(postDesc: String, author: String, imageurl: String?){
        self._postDesc = postDesc
        self._authKey = author
        self._imageUrl = imageurl
    }
    
    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>){
        
        self._postKey = postKey
        
        if let author = dictionary["author"] as? String {
         self._authKey = author
        }
        
        if let likes = dictionary["likes"] as? Int {
            self._likes = likes
        }
        
        if let imgUrl = dictionary["imageurl"] as? String {
            self._imageUrl = imgUrl
        }
        
        if let desc = dictionary["description"] as? String {
            self._postDesc = desc
        }
        
        if let timestamp = dictionary["timestamp"] as? NSDate {
            self._postTimeStamp = timestamp
        }
        
        self._postRef = DataService.dataService.REF_POSTS.childByAppendingPath(self._postKey)
        
    }
    
    func adjustLikes(addLike: Bool){
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
    
        }
        
        _postRef.childByAppendingPath("likes").setValue(_likes)
        
    }
}