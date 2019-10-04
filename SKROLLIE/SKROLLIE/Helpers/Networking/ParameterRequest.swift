//
//  ApiParameter.swift
//  SKROLLIE
//
//  Created by Smit Patel on 19/03/19.
//  Copyright © 2018 Smit Patel. All rights reserved.
//

import Foundation

class ParameterRequest {

    var parameters = [String: Any]()

    static let username = "username"
    static let password = "password"
    static let emailaddress = "emailaddress"
    static let Birthdate = "Birthdate"
    static let id = "id"
    static let idUser = "idUser"
    static let IsWatch = "IsWatch"
    static let iduser = "iduser"
    static let udid = "udid"
    static let PushNotificationId = "PushNotificationId"
    static let UserId = "UserId"
    static let oldpassword = "oldpassword"
    static let Password = "Password"
    static let confirmpassword = "confirmpassword"
    static let idFriend = "idFriend"
    static let IsBlock = "IsBlock"
    static let isPhoto = "isPhoto"
    static let Url = "Url"
    static let Description  = "Description"
    static let Emoji1  = "Emoji1"
    static let Emoji2 = "Emoji2"
    static let isPublish  = "isPublish"
    static let Isforever = "Isforever"
    static let Videothumbnailimage = "Videothumbnailimage"
    static let image = "image"
    static let ProfileName = "ProfileName"
    static let description = "description"
    static let FullName = "FullName"
    static let AKA = "AKA"
    static let attachimage = "attachimage"
    static let ReportedByUserId = "ReportedByUserId"
    static let ReportedToUserId = "ReportedToUserId"
    static let ReportedPostId = "ReportedPostId"
    static let IsPublic = "IsPublic"
    static let idPost = "idPost"
    static let Emoji = "Emoji"
    static let PostId = "PostId"
    static let Comment = "Comment"
    static let idComment = "idComment"
    
    init(){
    }
    
    func addParameter(key: String, value: Any?) {
        parameters[key] = value
    }
    
}


class FileParameterRequest {
    var parameters = [String: Any]()
    
    static let file_data = "file_data"
    static let param_name = "param_name"
    static let file_name = "file_name"
    static let mime_type = "mime_type"
    
    init(){}
    
    func addParameter(key: String, value: Any?) {
        parameters[key] = value
    }
}
