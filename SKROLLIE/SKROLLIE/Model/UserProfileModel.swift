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
    var createdby = ""
    var createddate = ""
    var modifiedby = ""
    var modifieddate = ""
    var OTPTIME = ""
    
    var TotalTodayPost = ""
    var TotalForeverPost = ""
    
    init(data: [String: Any], totalTodayPost: String, totalForeverPost: String) {
        username = data["username"] as? String ?? ""
        image = data["image"] as? String ?? ""
        createdby = data["createdby"] as? String ?? ""
        TotalTodayPost = totalTodayPost
        TotalForeverPost = totalForeverPost
    }
}

