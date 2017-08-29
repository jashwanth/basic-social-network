//
//  Post.swift
//  basic-social-network
//
//  Created by jashwanth reddy gangula on 8/24/17.
//  Copyright © 2017 jashwanth reddy gangula. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postRef: DatabaseReference!
    var caption: String {
        return _caption
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(caption: String, imageUrl: String, likes: Int, postKey: String) {
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
        self._postKey = postKey
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        
        _postRef = DataService.ds.REF_POSTS.child(self._postKey)
    }
    
    func adjustLikes(addLike: Bool) {
        if addLike {
          self._likes = self._likes + 1
        } else {
          self._likes = self._likes - 1
        }
        _postRef.child("likes").setValue(self._likes)
    }
}
