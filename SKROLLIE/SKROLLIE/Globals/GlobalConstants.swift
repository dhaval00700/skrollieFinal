//
//  GlobalConstants.swift
//  SKROLLIE
//
//  Created by Smit Patel on 19/03/19.
//  Copyright © 2019 Smit Patel. All rights reserved.
//

import UIKit
import AWSS3
import AWSCore

// MARK: - Global variables
var isDevelopmentMode   = true
var enableProductionApi = false

// MARK: - Colors
struct AppColor {
    static let BLUE             =   #colorLiteral(red: 0, green: 0.1254901961, blue: 0.5725490196, alpha: 1)
    static let SKY_BLUE         =   #colorLiteral(red: 0.1019607843, green: 0.7254901961, blue: 0.7843137255, alpha: 1)
    static let DARK_GRADIANT    =   #colorLiteral(red: 0.2941176471, green: 0.2941176471, blue: 0.2941176471, alpha: 1)
    static let LIGHT_GRADIANT   =   #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    static let DARK_RED         =   #colorLiteral(red: 0.9098039216, green: 0.3725490196, blue: 0.3568627451, alpha: 1)
    static let LIGHT_GRAY       =   #colorLiteral(red: 0.9647058824, green: 0.9725490196, blue: 0.9764705882, alpha: 1)
    static let GREEN            =   #colorLiteral(red: 0.4235294118, green: 0.8392156863, blue: 0.8431372549, alpha: 1)
    static let BLACK            =   #colorLiteral(red: 0.231372549, green: 0.3137254902, blue: 0.3921568627, alpha: 1)
    static let MEDIUM_GRAY      =   #colorLiteral(red: 0.9450980392, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
    static let DARK_GRAY        =   #colorLiteral(red: 0.7725490196, green: 0.8117647059, blue: 0.8392156863, alpha: 1)
    static let KEY              =   #colorLiteral(red: 0.9568627451, green: 0.4862745098, blue: 0.2823529412, alpha: 1)
}

// MARK: - For AWS Config
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

let PROGRESS_NOTIFICATION_KEY                  =   Notification.Name("PROGRESS_NOTIFICATION_KEY")
let REFRESH_NOTIFICATION_KEY                   =   Notification.Name("REFRESH_NOTIFICATION_KEY")

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

// MARK: - Constants
var PostCountLimit = 5
var TwentyFourHourStr = "24 Hour"
var ForeverStr = "Forever"
var RefreshStr = "Updating Connections..."

// MARK: - For Emoji
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


enum AccountVerifyStatus : Int {
    case zero = 0
    case one = 1
    case two = 2
    
    func description() -> (String) {
        switch self {
        case .zero:
            return ""
        case .one:
            return "Pending"
        case .two:
            return "Approved"
        }
    }
}

// MARK: - FontName
enum FontName: String {
    case montserratThin    =   "MONTSERRAT-THIN"
    case montserratLight   =   "MONTSERRAT-LIGHT"
    case montserratBold    =   "MONTSERRAT-BOLD"
    case montserratRegular =   "MONTSERRAT-REGULAR"
    case montserratMedium  =   "MONTSERRAT-MEDIUM"
}

// MARK: - API
struct API {
    static var BASE_URL = enableProductionApi ? "http://103.232.124.170:18012/" : "http://103.232.124.170:18012/"
    
    static let Login     =   BASE_URL + "MobileAccount/Mobilelogin"
    static let Register     =   BASE_URL + "MobileAccount/register"
    static let SavePost     =   BASE_URL + "MobilePost/SavePost"
    static let CreateFriend     =   BASE_URL + "MobilePost/CreateFriend"
    static let SendOTP     =   BASE_URL + "MobileAccount/SendOTP"
    static let CheckEmailValidator = BASE_URL + "MobileAccount/CheckEmailValidator"
    static let CheckEmailExist = BASE_URL + "MobileAccount/CheckEmailExist"
    static let CheckUserExist = BASE_URL + "MobileAccount/CheckUserExist"
    static let CheckPhoneExist = BASE_URL + "MobileAccount/CheckPhoneExist"
    static let VerifyOTP = BASE_URL + "MobileAccount/VerifyOTP"
    static let GetAllPost = BASE_URL + "MobilePost/GetAllPost"
    static let GetAllPostByIdUser = BASE_URL + "MobilePost/GetAllPostByIdUser"
    static let DeletePost = BASE_URL + "MobilePost/DeletePost"
    static let GetLatest24HoursPostByUser = BASE_URL + "MobilePost/GetLatest24HoursPostByUser"
    static let GetForeverPostByUser = BASE_URL + "MobilePost/GetForeverPostByUser"
    static let GetUserById = BASE_URL + "MobileAccount/GetUserById"
    static let UpdateUserById = BASE_URL + "MobileAccount/UpdateUserById"
    static let GetAllMyFriend = BASE_URL + "MobileAccount/GetAllMyFriend"
    static let GetAllMyUnFriend = BASE_URL + "MobileAccount/GetAllMyUnFriend"
    static let GetAllBlockFriendByUser = BASE_URL + "MobilePost/GetAllBlockFriendByUser"
    static let UpdateFriendStatus = BASE_URL + "MobilePost/UpdateFriendStatus"
    static let ChangePassword = BASE_URL + "MobileAccount/changepassword"
}
