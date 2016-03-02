//
//  Post.swift
//  GoodR
//
//  Created by Sam Rabeeh on 2016-03-02.
//  Copyright © 2016 Sam Rabeeh - RCI. All rights reserved.
//

import Foundation
class Post {
    
    private var _postDesc: String!
    private var _imageUrl: String?
    private var _likes: Int!
    private var _userName: String!
    private var _postKey: String!
    
    
    var postDescription: String{
        return _postDesc
    }
    
    var imageUrl: String! {
        return _imageUrl
    }
    
    var likes: Int! {
        return _likes
    }
    
    var userName: String!{
        return _userName
    }
    
    init(postDescrption: String, imageurl: String?, username: String){
        
        self._postDesc = postDescrption
        self._imageUrl = imageurl
        self._userName = username
    }
    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>){
        
        self._postKey = postKey
        
        if let likes = dictionary["likes"] as? Int {
            self._likes = likes
        }
        
        if let imgUrl = dictionary["imageurl"] as? String {
            self._imageUrl = imgUrl
        }
        
        if let desc = dictionary["description"] as? String {
            self._postDesc = desc
        }
    }
}