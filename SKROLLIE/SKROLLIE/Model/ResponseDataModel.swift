//
//  ResponseDataModel.swift
//  SKROLLIE
//
//  Created by Smit Patel on 19/03/19.
//  Copyright © 2019 Smit Patel. All rights reserved.
//

import Foundation

class ResponseDataModel {
    
    var success: Bool!
    var message: String!
    var data: Any?
    
    init() {}
    
    init(responseObj: [String : Any]) {
        success = responseObj["success"] as? Bool ?? false
        message = responseObj["message"] as? String ?? ""
        data = responseObj["data"]
    }
}
