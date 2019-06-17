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
let CreateFrnd = WebserviceURLs.kCreateFriend

//GET METHOD
let getPhoto = WebserviceURLs.kgetPhoto
let getAllPostByIdUser = WebserviceURLs.kGetAllPostByIdUser
let DeletePhoto = WebserviceURLs.kDeletePost






//------------------------------------------------------------
// MARK: - Webservice For GetPhoto
//------------------------------------------------------------
func webserviceForGetPhoto(id: String,  completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = getPhoto + "?idUser=" + "\(id)"
    print(url)
    getData([] as AnyObject, nsURL: url, completion: completion)
}

//------------------------------------------------------------
// MARK: - Webservice For GetAllPostByIdUser
//------------------------------------------------------------
func webserviceForGetAllPostByIdUser(id: String,  completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = getAllPostByIdUser + "?idUser=" + "\(id)"
    print(url)
    getData([] as AnyObject, nsURL: url, completion: completion)
}

//------------------------------------------------------------
// MARK: - Webservice For DeletePhoto
//------------------------------------------------------------
func webserviceForDeletePhoto(dictParams: AnyObject,completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = DeletePhoto + "\(dictParams)"
    print(url)
    getData(dictParams, nsURL: url, completion: completion)
}

//------------------------------------------------------------
// MARK: - Webservice For CreateFrnd Post
//------------------------------------------------------------

func webserviceForCreateFrnd(_ dictParams: AnyObject, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = CreateFrnd
    postData(dictParams, nsURL: url, completion: completion)
}

//-------------------------------------------------------------
// MARK: - Webservice For Save profile
//-------------------------------------------------------------
//func webserviceOfSaveProfile(_ dictParams: AnyObject, image1: UIImage, completion: @escaping(_ result: AnyObject, _ success: Bool) -> Void)
//{
//    let url = SaveProfile
//    sendImage(dictParams, image1: image1, nsURL: url, completion: completion)
//}

