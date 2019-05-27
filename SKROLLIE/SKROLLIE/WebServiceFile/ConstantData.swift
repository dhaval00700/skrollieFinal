//
//  SKROLLIE
//
//  Created by Dhaval Bhanderi on 4/16/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//
import Foundation
import UIKit

let kAPPVesion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

//-------------------------------------------------------------
// MARK: - ProfileData satatic key
//-------------------------------------------------------------
struct login
{
    static let kProfileData = "profile"
}

//-------------------------------------------------------------
// MARK: - WebserviceURLs
//-------------------------------------------------------------
struct WebserviceURLs {
    
    static let kBaseURL = "http://103.232.124.170:18012/MobileAccount/"
    static let kBaseImageURL = ""
    
    //POST
    
    static let kInit = "rest_api/init"
    static let klogin = "Mobilelogin?"
    static let kRegister = "register"
    
    //GET
    
    
    static let kOTPMobileNum = "http://103.232.124.170:18012/MobileAccount/SendOTP?"
    static let kVerifyOTP = "http://103.232.124.170:18012/MobileAccount/VerifyOTP?"
    static let KMonileNumCheckForRegister = "http://103.232.124.170:18012/MobileAccount/CheckPhoneExist?"
    static let kEmailIdVerification = "http://103.232.124.170:18012/MobileAccount/CheckEmailExist?"
    static let kUserNameVerification = "http://103.232.124.170:18012/MobileAccount/CheckUserExist?"
    static let kEmailFormatcheck = "http://103.232.124.170:18012/MobileAccount/CheckEmailValidator?"
}

struct keyAllKey
{
    static let kUsername = "username"
    static let kPassword = "password"
    static let kEmailaddress = "emailaddress"
    static let kBirthdate = "Birthdate"
    static let KidUser = "idUser"
    static let Kphone = "phone"
    static let kOTP = "OTP"
    static let KPhone = "phone"
    
}
