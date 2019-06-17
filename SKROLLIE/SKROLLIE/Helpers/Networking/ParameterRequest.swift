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
    static let isPhoto = "isPhoto"
    static let Url = "Url"
    static let Description  = "Description"
    static let Emoji1  = "Emoji1"
    static let Emoji2 = "Emoji2"
    static let isPublish  = "isPublish"
    static let Isforever = "Isforever"
    static let Videothumbnailimage = "Videothumbnailimage"

    
    
    init(){
    }
    
    func addParameter(key: String, value: Any?) {
        parameters[key] = value
    }
    
}
