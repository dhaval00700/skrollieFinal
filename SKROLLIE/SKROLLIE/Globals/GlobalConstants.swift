//
//  GlobalConstants.swift
//  SKROLLIE
//
//  Created by Smit Patel on 19/03/19.
//  Copyright © 2019 Smit Patel. All rights reserved.
//

import UIKit

//MARK: - Global variables
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

// MARK: - FontName
enum FontName: String {
    case montserratThin    =   "MONTSERRAT-THIN"
    case montserratLight   =   "MONTSERRAT-LIGHT"
    case montserratBold    =   "MONTSERRAT-BOLD"
    case montserratRegular =   "MONTSERRAT-REGULAR"
    case montserratMedium  =   "MONTSERRAT-MEDIUM"
}

// MARK: - Login Type
enum LoginType: String {
    case local = "LOCAL"
    case facebook = "FB"
}

//MARK: - API
struct API {
    static var BASE_URL = enableProductionApi ? "http://103.232.124.170:18012/" : "http://103.232.124.170:18012/"
    
    
    static let Login     =   BASE_URL + "MobileAccount/Mobilelogin?"
    static let Register     =   BASE_URL + "MobileAccount/register"
    static let SavePost     =   BASE_URL + "MobilePost/SavePost"
    static let CreateFriend     =   BASE_URL + "MobilePost/CreateFriend"
    static let SendOTP     =   BASE_URL + "MobileAccount/SendOTP"
}
