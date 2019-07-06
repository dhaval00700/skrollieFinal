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
    
    var FullName = ""
    var IsAccountVerify = AccountVerifyStatus.one
    var IsMyFriend = false
    var idUser = ""
    var image = ""
    var username = ""
    
    var map: Map!
    
    init(_ data: [String:AnyObject]) {
        map = Map(data: data)

        FullName = map.value("FullName") ?? ""
        let staus = map.value("IsAccountVerify") ?? 0
        IsAccountVerify = AccountVerifyStatus(rawValue: staus)!
        IsMyFriend = map.value("IsMyFriend") ?? false
        idUser = map.value("idUser") ?? ""
        let str = (map.value("image") ?? "")
        if str.contains(prefixDataUrl) {
            image = (map.value("image") ?? "")
        } else {
            image = prefixDataUrl + (map.value("image") ?? "")
        }
        username = map.value("username") ?? ""

    }
    
    class func getArray(data: [AnyObject]) -> [UserFriendList] {
        var arrPost = [UserFriendList]()
        
        for temp in data {
            arrPost.append(UserFriendList(temp as? [String : AnyObject] ?? [String : AnyObject]()))
        }
        
        return arrPost
    }
}
