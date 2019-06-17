//
//  ApiParameter.swift
//  Trustfund
//
//  Created by Smit Patel on 19/03/19.
//  Copyright © 2018 Smit Patel. All rights reserved.
//

import Foundation

class ParameterRequest {

    var parameters = [String: Any]()

    static let email = "email"
    static let pin = "pin"
    static let first_name = "first_name"
    static let last_name = "last_name"
    static let state_id = "state_id"
    static let mobile_number = "mobile_number"
    
    init(){
        //addParameter(key: ParameterRequest.device_type, value: "ios")
        //addParameter(key: ParameterRequest.device_token, value: AppPrefsManager.shared.getFcmToken())
        //addParameter(key: ParameterRequest.device_id, value: Utility.getAppUniqueId())
    }
    
    func addParameter(key: String, value: Any?) {
        parameters[key] = value
    }
    
}
