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
    
    static let xAccessToken = "x-access-token"
    
    init() {
        /*if(AppPrefsManager.shared.isUserLoggedIn()) {
            addParameter(key: HeaderRequestParameter.xAccessToken, value: AppPrefsManager.shared.getUserToken())
        }*/
    }

    func addParameter(key: String, value: String) {
        parameters[key] = value
    }
}
