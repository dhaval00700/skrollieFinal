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
    
    var map: Map!
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
    var EndDate = Date()
    var timer = Timer()
    var timeIntervalFromCurrent = 0.0
    
    init(Post: [String: Any], userName: String) {
        map = Map(data: Post)
        Postid = map.value("PostId") ?? ""
        idUser = map.value("idUser") ?? ""
        isPhoto = map.value("isPhoto") ?? false
        Isforever = map.value("Isforever") ?? false
        isPublish = map.value("isPublish") ?? false
        Description = map.value("Description") ?? ""
        Emoji1 = map.value("Emoji1") ?? ""
        Emoji2 = map.value("Emoji2") ?? ""
        CreatedDate = map.value("CreatedDate") ?? ""
        CreatedBy = map.value("CreatedBy") ?? ""
        Videothumbnailimage = map.value("Videothumbnailimage") ?? ""
        if isPhoto {
            Url = prefixDataUrl + "\(map.value("Url") ?? "")"
        } else {
            Url = prefixDataUrl + "\(map.value("Videothumbnailimage") ?? "")"
        }
        UserName = userName
        let date = CreatedDate.getDateWithFormate(formate: "yyyy-MM-dd'T'HH:mm:ss.ssz", timezone: "UTC")
        EndDate = date.addDays(1)
        timeIntervalFromCurrent = Double(EndDate.seconds(from: Date()))
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
    var map: Map!
    var ProfileName = ""
    var ProfileImage = ""
    var arrPost = [Post]()
    
    init(data: [String: Any]) {
        map = Map(data: data)
        ProfileName = map.value("ProfileName") ?? ""
        ProfileImage = prefixDataUrl + "\(map.value("ProfileImage") ?? "")"
        let post = map.value("Post") ?? [[String:Any]]()
        arrPost = Post.getArrayPost(data: post, userName: ProfileName)
    }
    class func getArrayPost(datas: [[String: Any]]) -> [UserData] {
        var arydata = [UserData]()
        for temp in datas {
            arydata.append(UserData(data: temp))
        }
        return arydata
    }
}
