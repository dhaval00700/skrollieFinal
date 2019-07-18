//
//  UserFriendList.swift
//  SKROLLIE
//
//  Created by PC on 06/07/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import Foundation



class UserFriendList {
    
    init() {}
    
    var username = ""
    var FullName = ""
    var IsAccountVerify = AccountVerifyStatus.one
    var IsPublic = false
    var image = ""
    var idUser = ""
    var TodayPost = ""
    var ForeverPost = ""
    
    var map: Map!
    
    init(_ data: [String:Any]) {
        map = Map(data: data)

        username = map.value("username") ?? ""
        FullName = map.value("FullName") ?? ""
        let staus = map.value("IsAccountVerify") ?? 0
        IsAccountVerify = AccountVerifyStatus(rawValue: staus)!
        idUser = map.value("idUser") ?? ""
        let str = (map.value("image") ?? "")
        if str.contains(prefixDataUrl) {
            image = (map.value("image") ?? "")
        } else {
            image = prefixDataUrl + (map.value("image") ?? "")
        }
        TodayPost = map.value("TodayPost") ?? ""
        ForeverPost = map.value("ForeverPost") ?? ""
    }
    
    class func getArray(data: [[String: Any]]) -> [UserFriendList] {
        var arrPost = [UserFriendList]()
        
        for temp in data {
            arrPost.append(UserFriendList(temp))
        }
        
        return arrPost
    }
}
