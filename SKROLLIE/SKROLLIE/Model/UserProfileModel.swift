//
//  UserProfileModel.swift
//  SKROLLIE
//
//  Created by PC on 27/06/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import Foundation
import UIKit

class UserProfileModel {
    
    init() {}
    var map : Map!
    var id = ""
    var idrole = ""
    var username = ""
    var password = ""
    var emailaddress = ""
    var ProfileName = ""
    var phone = ""
    var country = ""
    var state = ""
    var city = ""
    var gender = ""
    var image = ""
    var Birthdate = ""
    var IsDelete = false
    var OTP = ""
    var IsMobileVerify = false
    var IsPublic = false
    var createdby = ""
    var createddate = ""
    var modifiedby = ""
    var modifieddate = ""
    var OTPTIME = ""
    var description = ""
    var FullName = ""
    var AKA = ""
    var attachimage = ""
    var IsAccountVerify = AccountVerifyStatus.one
    var TotalTodayPost = ""
    var TotalForeverPost = ""
    
    init(data: [String: Any], totalTodayPost: String, totalForeverPost: String) {
        map = Map(data: data)
        id = map.value("id") ?? ""
        idrole = map.value("idrole") ?? ""
        username = map.value("username") ?? ""
        password = map.value("password") ?? ""
        emailaddress = map.value("emailaddress") ?? ""
        ProfileName = (map.value("ProfileName") ?? "").decode()
        phone = map.value("phone") ?? ""
        country = map.value("country") ?? ""
        state = map.value("state") ?? ""
        city = map.value("city") ?? ""
        gender = map.value("gender") ?? ""
        let str = (map.value("image") ?? "")
        if str.contains(prefixDataUrl) {
            image = (map.value("image") ?? "")
        } else {
            image = prefixDataUrl + (map.value("image") ?? "")
        }
        Birthdate = map.value("Birthdate") ?? ""
        IsDelete = map.value("IsDelete") ?? false
        OTP = map.value("OTP") ?? ""
        IsMobileVerify = map.value("IsMobileVerify") ?? false
        IsPublic = map.value("IsPublic") ?? false
        createdby = map.value("createdby") ?? ""
        createddate = map.value("createddate") ?? ""
        modifiedby = map.value("modifiedby") ?? ""
        modifieddate = map.value("modifieddate") ?? ""
        OTPTIME = map.value("OTPTIME") ?? ""
        description = (map.value("description") ?? "").decode()
        FullName = map.value("FullName") ?? ""
        AKA = map.value("AKA") ?? ""
        attachimage = map.value("attachimage") ?? ""
        let staus = map.value("IsAccountVerify") ?? 0
        IsAccountVerify = AccountVerifyStatus(rawValue: staus)!
        TotalTodayPost = totalTodayPost
        TotalForeverPost = totalForeverPost
    }
    
    func toDictionary() -> [String : Any] {
        var itemDict = [String : Any]()
        
        itemDict["id"] = id
        itemDict["idrole"] = idrole
        itemDict["username"] = username
        itemDict["password"] = password
        itemDict["emailaddress"] = emailaddress
        itemDict["ProfileName"] = ProfileName
        itemDict["phone"] = phone
        itemDict["country"] = country
        itemDict["state"] = state
        itemDict["city"] = city
        itemDict["gender"] = gender
        itemDict["image"] = image
        itemDict["Birthdate"] = Birthdate
        itemDict["IsDelete"] = IsDelete
        itemDict["OTP"] = OTP
        itemDict["IsMobileVerify"] = IsMobileVerify
        itemDict["IsPublic"] = IsPublic
        itemDict["createdby"] = createdby
        itemDict["createddate"] = createddate
        itemDict["modifiedby"] = modifiedby
        itemDict["modifieddate"] = modifieddate
        itemDict["OTPTIME"] = OTPTIME
        itemDict["description"] = description
        itemDict["FullName"] = FullName
        itemDict["AKA"] = AKA
        itemDict["attachimage"] = attachimage
        switch IsAccountVerify {
        case .zero:
            itemDict["IsAccountVerify"] = 0
        case .one:
            itemDict["IsAccountVerify"] = 1
        case .two:
            itemDict["IsAccountVerify"] = 2
        }
        itemDict["TotalTodayPost"] = TotalTodayPost
        itemDict["TotalForeverPost"] = TotalForeverPost
        
        return itemDict
    }
    
    class func getArray(data: [[String: Any]]) -> [UserProfileModel] {
        var arrPost = [UserProfileModel]()
        
        for temp in data {
            arrPost.append(UserProfileModel(data: temp, totalTodayPost: "", totalForeverPost: ""))
        }
        
        return arrPost
    }
}

class BlockListData {
    
    init() {}
    
    var map : Map!
    var id = ""
    var idUser = ""
    var idFriend = ""
    var Isstatus = ""
    var CreatedDate = ""
    var CreatedBy = ""
    var ModifiedDate = ""
    var ModifiedBy = ""
    var tbluserinformation = UserProfileModel()
    
    init(data: [String: Any]) {
        map = Map(data: data)
        id = map.value("id") ?? ""
        idUser = map.value("idUser") ?? ""
        idFriend = map.value("idFriend") ?? ""
        Isstatus = map.value("Isstatus") ?? ""
        CreatedDate = map.value("CreatedDate") ?? ""
        CreatedBy = map.value("CreatedBy") ?? ""
        ModifiedDate = map.value("ModifiedDate") ?? ""
        ModifiedBy = map.value("ModifiedBy") ?? ""
        let userData = map.value("tbluserinformation") ?? [String:Any]()
        tbluserinformation = UserProfileModel(data: userData, totalTodayPost: "", totalForeverPost: "")
    }
    
    class func getArray(data: [[String: Any]]) -> [BlockListData] {
        var arrPost = [BlockListData]()
        
        for temp in data {
            arrPost.append(BlockListData(data: temp))
        }
        
        return arrPost
    }
}
