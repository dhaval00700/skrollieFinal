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
    
    init(){
    }
    
    func addParameter(key: String, value: Any?) {
        parameters[key] = value
    }
    
}
