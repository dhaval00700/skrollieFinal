//
//  UserLike.swift
//  SKROLLIE
//
//  Created by Anji on 29/08/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import Foundation
import UIKit


class UserLike {
    
    init() {}
    
    var map: Map!
    var Emoji = 0
    var TotalLike = ""
    var arrLikeUsers = [UserProfileModel]()
    var likeEmoji = UIImage()
    
    
    init(Post: [String: Any], userName: String) {
        map = Map(data: Post)
        Emoji = map.value("Emoji") ?? 0
        TotalLike = map.value("TotalLike") ?? ""
        likeEmoji = EmojiStatus(rawValue: Emoji)!.description()
        
        let likeU = map.value("LikeUsers") ?? [[String : Any]]()
        arrLikeUsers = UserProfileModel.getArray(data: likeU)
        
    }
    
    class func getArray(data: [[String: Any]]) -> [UserLike] {
        var arrPost = [UserLike]()
        
        for temp in data {
            arrPost.append(UserLike(Post: temp,userName: ""))
        }
        
        return arrPost
    }
}
