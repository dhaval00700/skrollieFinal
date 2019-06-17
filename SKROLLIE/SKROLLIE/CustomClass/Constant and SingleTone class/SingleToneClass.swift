//
//  SingleToneClass.swift
//  SKROLLIE
//
//  Created by Dhaval Bhanderi on 4/17/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit
import AWSS3
import AWSCore

class SingleToneClass: NSObject {
    
    static let sharedInstance = SingleToneClass()
    
    var strDeviceToken = String()
    var loginDataStore = [String:AnyObject]()

}

class Constants {
    static let appBackColor = UIColor(red: 247/255, green: 250/255, blue: 253/255, alpha: 1)
    //    let NotificationforUpdateOrganisations = NSNotification.Name("UpdateOrganisations")
    
}

//MARK: For Notification
let NotificationforUpdateOrganisations = NSNotification.Name("UpdateOrganisations")


//MARK: For AWS Config
private enum SpaceRegion: String {
    case sfo = "sfo2", ams = "ams3", sgp = "sgp1"
    
    var endpointUrl: String {
        return "https://dhaval.sfo2.digitaloceanspaces.com"
    }
}
let accessKey = "AFIVAMHKVZGA4FUSWKNY"
let secretKey = "kP0tXinC+JwAHmH45mQllU1vrKx4MtHdX6BcJD18zWg"
let regionEndpoint = AWSEndpoint(urlString: SpaceRegion.sfo.endpointUrl)
let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
let configuration = AWSServiceConfiguration(region: .USEast1, endpoint: regionEndpoint, credentialsProvider: credentialsProvider)

let prefixDataUrl = "https://dhaval.sfo2.digitaloceanspaces.com/Jayesh/"


let transformerTypes: [FSPagerViewTransformerType] = [.linear,.crossFading,
                                                                  .zoomOut,
                                                                  .depth,
                                                                  .linear,
                                                                  .overlap,
                                                                  .ferrisWheel,
                                                                  .invertedFerrisWheel,
                                                                  .coverFlow,
                                                                  .cubic]
var timestamp: String {
    return "\(NSDate().timeIntervalSince1970 * 1000)"
}


//MARK: For Emoji
var arrEmoji = [#imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "2.png"), #imageLiteral(resourceName: "3"), #imageLiteral(resourceName: "4"), #imageLiteral(resourceName: "5"), #imageLiteral(resourceName: "6"), #imageLiteral(resourceName: "7"), #imageLiteral(resourceName: "8"), #imageLiteral(resourceName: "9.png"), #imageLiteral(resourceName: "10.png")]

func returnEmojiNumber(img: UIImage) -> String {
    switch img {
    case #imageLiteral(resourceName: "1"):
        return "1"
    case #imageLiteral(resourceName: "2.png"):
        return "2"
    case #imageLiteral(resourceName: "3"):
        return "3"
    case #imageLiteral(resourceName: "4"):
        return "4"
    case #imageLiteral(resourceName: "5"):
        return "5"
    case #imageLiteral(resourceName: "6"):
        return "6"
    case #imageLiteral(resourceName: "7"):
        return "7"
    case #imageLiteral(resourceName: "8"):
        return "8"
    case #imageLiteral(resourceName: "9.png"):
        return "9"
    case #imageLiteral(resourceName: "10.png"):
        return "10"
    default:
        return ""
    }
}

enum Emoji : Int {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case ten = 10
    
    func description() -> (UIImage) {
        switch self {
        case .one:
            return (#imageLiteral(resourceName: "1.png"))
        case .two:
            return (#imageLiteral(resourceName: "2.png"))
        case .three:
            return (#imageLiteral(resourceName: "3.png"))
        case .four:
            return (#imageLiteral(resourceName: "4"))
        case .five:
            return (#imageLiteral(resourceName: "5.png"))
        case .six:
            return (#imageLiteral(resourceName: "6.png"))
        case .seven:
            return (#imageLiteral(resourceName: "7.png"))
        case .eight:
            return (#imageLiteral(resourceName: "8.png"))
        case .nine:
            return (#imageLiteral(resourceName: "9.png"))
        case .ten:
            return (#imageLiteral(resourceName: "10.png"))
        }
    }
}
