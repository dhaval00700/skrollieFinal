//
//  SKROLLIE
//
//  Created by Dhaval Bhanderi on 4/16/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//
import Foundation
import UIKit

let kAPPVesion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

//-------------------------------------------------------------
// MARK: - ProfileData satatic key
//-------------------------------------------------------------
struct login
{
    static let kProfileData = "profile"
}

//-------------------------------------------------------------
// MARK: - WebserviceURLs
//-------------------------------------------------------------
struct WebserviceURLs {
    
    static let kBaseURL = "http://103.232.124.170:18012/"
    static let kBaseImageURL = ""
    
    //POST

    static let kCreateFriend = "MobilePost/CreateFriend"
    
    //GET
    
    static let kgetPhoto = "http://103.232.124.170:18012/MobilePost/GetAllPost"
    static let kGetAllPostByIdUser = "http://103.232.124.170:18012/MobilePost/GetAllPostByIdUser"
    static let kDeletePost = "http://103.232.124.170:18012/MobilePost/DeletePost?"
}

struct keyAllKey
{
    static let kUsername = "username"
    static let kPassword = "password"
    static let kEmailaddress = "emailaddress"
    static let kBirthdate = "Birthdate"
    static let KidUser = "idUser"
    static let Kphone = "phone"
    static let kOTP = "OTP"
    static let KPhone = "phone"
    static let id = "id"
    static let isPhoto = "isPhoto"
    static let Url = "Url"
    static let Description  = "Description"
    static let Emoji1  = "Emoji1"
    static let Emoji2 = "Emoji2"
    static let isPublish  = "isPublish"
    static let idFriend = "idFriend"
    static let Isstatus = "Isstatus"
    static let Isforever = "Isforever"
    static let Videothumbnailimage = "Videothumbnailimage"
}
