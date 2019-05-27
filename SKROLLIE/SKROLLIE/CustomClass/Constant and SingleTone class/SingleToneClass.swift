//
//  SingleToneClass.swift
//  SKROLLIE
//
//  Created by Dhaval Bhanderi on 4/17/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit

class SingleToneClass: NSObject {
    
    static let sharedInstance = SingleToneClass()
    
    var strDeviceToken = String()
    var loginDataStore = [String:AnyObject]()

}

class Constants {
    static let appBackColor = UIColor(red: 247/255, green: 250/255, blue: 253/255, alpha: 1)
    //    let NotificationforUpdateOrganisations = NSNotification.Name("UpdateOrganisations")
    
}

let NotificationforUpdateOrganisations = NSNotification.Name("UpdateOrganisations")

