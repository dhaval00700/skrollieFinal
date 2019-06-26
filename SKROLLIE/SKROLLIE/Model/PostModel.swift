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
    var idUser = ""
    var isPhoto = false
    var Isforever = false
    var isPublish = false
    var Url = ""
    var Description = ""
    var Emoji1 = ""
    var Emoji2 = ""
    var CreatedDate = ""
    var CreatedBy = ""
    var Videothumbnailimage = ""
    var UserName = ""
    
    init(Post: [String: Any], userName: String) {
        
        Postid = Post["PostId"] as? String ?? (Post["PostId"] as? NSNumber)?.stringValue ?? (Post["id"] as? NSNumber)?.stringValue ?? Post["id"] as? String ?? ""
        idUser = Post["idUser"] as? String ?? (Post["idUser"] as? NSNumber)?.stringValue ?? ""
        isPhoto = Post["isPhoto"] as? Bool ?? (Post["isPhoto"] as? NSNumber)?.boolValue ?? false
        Isforever = Post["Isforever"] as? Bool ?? (Post["Isforever"] as? NSNumber)?.boolValue ?? false
        isPublish = Post["isPublish"] as? Bool ?? (Post["isPublish"] as? NSNumber)?.boolValue ?? false
        Description = Post["Description"] as? String ?? ""
        Emoji1 = Post["id"] as? String ?? ""
        Emoji2 = Post["id"] as? String ?? ""
        CreatedDate = Post["CreatedDate"] as? String ?? ""
        CreatedBy = Post["CreatedBy"] as? String ?? ""
        Videothumbnailimage = Post["Videothumbnailimage"] as? String ?? ""
        
        if isPhoto {
            Url = prefixDataUrl + "\(Post["Url"] as? String ?? "")"
        } else {
            Url = prefixDataUrl + "\(Post["Videothumbnailimage"] as? String ?? "")"
        }
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

class GetPostData {
    
    init() {}
    
    var sectionName = ""
    var arrPostData = [[Post]]()
    
    init(_ data: [[[String: Any]]], _ name: String) {
        sectionName = name
        for temp in data {
            arrPostData.append(Post.getArrayPost(data: temp, userName: "").reversed())
        }
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
