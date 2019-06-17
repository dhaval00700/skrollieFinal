//
//  PostModel.swift
//  SKROLLIE
//
//  Created by bin on 04/06/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import Foundation
import UIKit

class Post {
    
    init() {}
    
    var Postid = ""
    var isPhoto = false
    var Isforever = false
    var Url = ""
    var Description = ""
    var Emoji1 = ""
    var Emoji2 = ""
    var CreatedDate = ""
    var UserName = ""
    
    init(Post: [String: Any], userName: String) {
        
        Postid = Post["PostId"] as? String ?? ""
        isPhoto = Post["isPhoto"] as? Bool ?? false
        Isforever = Post["Isforever"] as? Bool ?? false
        let url = prefixDataUrl + "\(Post["Url"] as? String ?? "")"
        Url = url
        Description = Post["Description"] as? String ?? ""
        Emoji1 = Post["id"] as? String ?? ""
        Emoji2 = Post["id"] as? String ?? ""
        CreatedDate = Post["CreatedDate"] as? String ?? ""
        UserName = userName
    }
    
    class func getArrayPost(data: [[String: Any]], userName: String) -> [Post] {
        var arrPost = [Post]()
        
        for temp in data {
            arrPost.append(Post(Post: temp,userName: userName))
        }
        
        return arrPost
    }
    
}

class UserData
{
    init(){}
    var ProfileName = ""
    var ProfileImage = ""
    var arrPost = [Post]()
    
    init(data: [String: Any]) {
        
        ProfileName = data["ProfileName"] as? String ?? ""
        ProfileImage = data["ProfileImage"] as? String ?? ""
        let post = data["Post"] as? [[String: Any]] ?? [[String:Any]]()
        arrPost = Post.getArrayPost(data: post, userName: ProfileName)
    }
    class func getArrayPost(datas: [[String: Any]]) -> [UserData] {
        var arydata = [UserData]()
        
        for temp in datas
        {
            arydata.append(UserData(data: temp))
        }

        return arydata
    }
}
