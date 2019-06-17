//
//  SKROLLIE
//
//  Created by Dhaval Bhanderi on 4/16/19.
//  Copyright © 2019 Dhaval Bhanderi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

let BaseURL = WebserviceURLs.kBaseURL
let baseTaskURL = WebserviceURLs.kBaseURL
var request : Request!



//-------------------------------------------------------------
// MARK: - Webservice For PostData Method
//-------------------------------------------------------------

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

func postData(_ dictParams: AnyObject, nsURL: String, completion: @escaping (_ result: AnyObject, _ sucess: Bool) -> Void)
{
    let url = WebserviceURLs.kBaseURL + nsURL
    print("url = \(url) params = \(dictParams)")
    let Token =  SingleToneClass.sharedInstance.loginDataStore["token"] as? String ?? ""
    let header: [String:String] = ["Content-Type":"application/json", "Authorization":Token]
    
    Alamofire.request(url, method: .post, parameters: dictParams as? [String : AnyObject], encoding: JSONEncoding.default, headers: header)
        .validate()
        .responseJSON
        { (response) in
            
            if let responsedata = response.data as? Data {
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: responsedata, options : .allowFragments) as? [String:Any]
                    {
                        print(jsonArray) // use the json here
                    } else {
                        print("bad json")
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            if((response.result.value != nil)){
                switch response.result {
                  
                    case .success( _):
                    if let JSON = response.result.value
                    {
                    if (JSON as AnyObject).object(forKey:("status")) as? Bool == false || (JSON as AnyObject).object(forKey:("success")) as? Bool == false
                    {
                        completion(JSON as AnyObject, false)
                    }
//                    else
//                    {
//                    completion(response.data as AnyObject, true)
//                    }
                    else {
                            completion(response.result.value as AnyObject, true)
                        }
                    }
                    else {
//                    completion(response.result.value as AnyObject, false)
                    
                    }
                    case .failure(_): break
                    
                    }
            }
    }
}

func getData(_ dictParams: AnyObject, nsURL: String,  completion: @escaping (_ result: AnyObject, _ success: Bool) -> Void)
{
    let url =  nsURL//WebserviceURLs.kBaseURL + nsURL
    print(url)

    Alamofire.request(url, method: .get, parameters: dictParams as? [String : AnyObject], encoding: URLEncoding.default)
        .validate()
        .responseJSON
        { (response) in
            
            if let JSON = response.result.value
            {
                
                if (JSON as AnyObject).object(forKey:("success")) as! Bool == true
                {
                    completion(JSON as AnyObject, true)
                }
                else
                {
                    completion(JSON as AnyObject, false)
                    
                }
            }
            else
            {
                print("Data not Found")
            }

    }
}


    //-------------------------------------------------------------
    // MARK: - Webservice For Send Image Method
    //-------------------------------------------------------------
    
    func sendImage(_ dictParams: AnyObject, image1: UIImage, nsURL: String, completion: @escaping (_ result: AnyObject, _ success: Bool) -> Void) {
        
        let url = WebserviceURLs.kBaseURL + nsURL
        
        let Token =  SingleToneClass.sharedInstance.loginDataStore["token"] as? String ?? ""
        let header: [String:String] = ["Content-Type":"application/json", "Authorization":Token]
        
        let dictData = dictParams as! [String:AnyObject]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if let imageData1 = UIImage.jpegData(image1)(compressionQuality: 0.3) {
                
                multipartFormData.append(imageData1, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            
            for (key, value) in dictData
            {
                
                print(value)
                multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
            }
        }, usingThreshold: 10 * 1024 * 1024, to: url, method: .post, headers: header) { (encodingResult) in
            switch encodingResult
            {
            case .success(let upload, _, _):
                request =  upload.responseJSON {
                    response in
                    
                    if let JSON = response.result.value {
                        
                        if ((JSON as AnyObject).object(forKey: "status") as! Bool) == true
                        {
                            completion(response.data as AnyObject, true)
                            print("If JSON")
                            
                        }
                        else
                        {
                            completion(JSON as AnyObject, false)
                            print("else JSON")
                        }
                    }
                    else
                    {
                        print("ERROR")
                    }
                    
                    
                }
            case .failure( _):
                print("failure")
                
                break
            }
        }
    }

