//
//  HeaderRequest.swift
//  SKROLLIE
//
//  Created by Smit Patel on 19/03/19.
//  Copyright © 2018 Smit Patel. All rights reserved.
//

import Foundation

class HeaderRequestParameter {
    var parameters = [String : String]()
    
    static let authorization = "Authorization"
    
    init() {
        if(AppPrefsManager.shared.isUserLogin()) {
            addParameter(key: HeaderRequestParameter.authorization, value: AppPrefsManager.shared.getUserData().token)
        }
    }

    func addParameter(key: String, value: String) {
        parameters[key] = value
    }
}
