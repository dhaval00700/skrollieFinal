//
//  ResponseDataModel.swift
//  SKROLLIE
//
//  Created by Smit Patel on 19/03/19.
//  Copyright © 2019 Smit Patel. All rights reserved.
//

import Foundation

class ResponseDataModel {
    var map: Map!
    var success = false
    var token = ""
    var message = ""
    var data: Any?
    
    init() {}
    
    init(responseObj: [String : Any]) {
        map = Map(data: responseObj)
        success = map.value("success") ?? false
        token = map.value("token") ?? ""
        message = map.value("message") ?? ""
        data = map.value("data")
    }
}
