//
//  SKROLLIE
//
//  Created by Dhaval Bhanderi on 4/16/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

//POST METHOD
let Login = WebserviceURLs.klogin
let Register = WebserviceURLs.kRegister

//GET METHOD
let OTPWithMobile = WebserviceURLs.kOTPMobileNum
let VerifyOTP = WebserviceURLs.kVerifyOTP
let VerifyMobileNumexistOrNot = WebserviceURLs.KMonileNumCheckForRegister
let VerifyEmail = WebserviceURLs.kEmailIdVerification
let VeriFyUserName = WebserviceURLs.kUserNameVerification
let EmailFormateCheck = WebserviceURLs.kEmailFormatcheck
//------------------------------------------------------------
// MARK: - Webservice For Register POst
//------------------------------------------------------------

func webserviceForRegister(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = Register
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Login GET
//-------------------------------------------------------------

func webserviceForLogin(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = Login// + "\(dictParams)"
    print(url)
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Otp
//-------------------------------------------------------------

func webserviceForOTPinMobile(dictParams: AnyObject,completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = OTPWithMobile + "\(dictParams)"
    print(url)
    getDataOTp(dictParams, nsURL: url, completion: completion)
}
//-------------------------------------------------------------
// MARK: - webservice For Verify OTP
//-------------------------------------------------------------

func webserviceForVerifyOTP(dictParams: AnyObject,completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = VerifyOTP + "\(dictParams)"
    print(url)
    getData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - webservice For Email Check
//-------------------------------------------------------------

func webserviceForEmailFormateCheck(dictParams: AnyObject,completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = EmailFormateCheck + "\(dictParams)"
    print(url)
    getData(dictParams, nsURL: url, completion: completion)
}
//-------------------------------------------------------------
// MARK: - webservice For Verify MobileNum is Exist Or Not
//-------------------------------------------------------------

func webserviceForVerifyMobileNumExistorNot(dictParams: AnyObject,completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = VerifyMobileNumexistOrNot + "\(dictParams)"
    print(url)
    getData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - webservice For Verify Email is Exist Or Not
//-------------------------------------------------------------

func webserviceForVerifyEmail(dictParams: AnyObject,completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = VerifyEmail + "\(dictParams)"
    print(url)
    getData(dictParams, nsURL: url, completion: completion)
}


func webserviceForUserName(dictParams: AnyObject,completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = VeriFyUserName + "\(dictParams)"
    print(url)
    getData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Save profile
//-------------------------------------------------------------
//func webserviceOfSaveProfile(_ dictParams: AnyObject, image1: UIImage, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
//{
//    let url = SaveProfile
//    sendImage(dictParams, image1: image1, nsURL: url, completion: completion)
//}

