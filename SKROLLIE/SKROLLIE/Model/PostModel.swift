//
//  PostModel.swift
//  SKROLLIE
//
//  Created by bin on 04/06/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import Foundation
import UIKit
import AVKit

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
    var IsAccountVerify = false
    var IsUnBlockPost = false
    
    var playerLayer = AVPlayerLayer()
    var avPlayer = AVPlayer()
    
    var LikeEmoji = ""
    
    
    init(Post: [String: Any], userName: String) {
        map = Map(data: Post)
        Postid = map.value("PostId") ?? ""
        if Postid.isEmpty {
            Postid = map.value("id") ?? ""
        }
        idUser = map.value("idUser") ?? ""
        isPhoto = map.value("isPhoto") ?? false
        Isforever = map.value("Isforever") ?? false
        isPublish = map.value("isPublish") ?? false
        IsAccountVerify = map.value("IsAccountVerify") ?? false
        IsUnBlockPost  = map.value("IsUnBlockPost") ?? false
        Description = map.value("Description") ?? ""
        LikeEmoji = map.value("LikeEmoji") ?? ""
        Emoji1 = map.value("Emoji1") ?? ""
        Emoji2 = map.value("Emoji2") ?? ""
        CreatedDate = map.value("CreatedDate") ?? ""
        CreatedBy = map.value("CreatedBy") ?? ""
        
        let str = (map.value("Url") ?? "")
        if !str.isEmpty {
            if str.contains(prefixDataUrl) {
                Url = (map.value("Url") ?? "")
            } else {
                Url = prefixDataUrl + (map.value("Url") ?? "")
            }
        }
        let str2 = (map.value("Videothumbnailimage") ?? "")
        if !str2.isEmpty {
            if str2.contains(prefixDataUrl) {
                Videothumbnailimage = (map.value("Videothumbnailimage") ?? "")
            } else {
                Videothumbnailimage = prefixDataUrl + (map.value("Videothumbnailimage") ?? "")
            }
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
    var IsAccountVerify = AccountVerifyStatus.one
    var arrPost = [Post]()
    
    init(data: [String: Any]) {
        map = Map(data: data)
        ProfileName = map.value("ProfileName") ?? ""
        ProfileImage = prefixDataUrl + "\(map.value("ProfileImage") ?? "")"
        let staus = map.value("IsAccountVerify") ?? 0
        IsAccountVerify = AccountVerifyStatus(rawValue: staus)!
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
