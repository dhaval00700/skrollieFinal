//
//  AppPrefsManager.swift
//  SKROLLIE
//
//  Created by Smit Patel on 19/03/19.
//  Copyright © 2019 Smit Patel. All rights reserved.
//

import Foundation

class AppPrefsManager {
    static let shared = AppPrefsManager()
    
    private let USER_LOGIN  =   "USER_LOGIN"
    private let USER_DATA_KEY  =   "USER_DATA_KEY"
    
    init() {
    }
    
    func setDataToPreference(data: Any, forKey key: String) {
        let archivedData = NSKeyedArchiver.archivedData(withRootObject: data)
        UserDefaults.standard.set(archivedData, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getDataFromPreference(key: String) -> AnyObject? {
        let archivedData = UserDefaults.standard.object(forKey: key)
        
        if(archivedData != nil) {
            return NSKeyedUnarchiver.unarchiveObject(with: archivedData! as! Data) as AnyObject?
        }
        return nil
    }
    
    func removeDataFromPreference(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func isKeyExistInPreference(key: String) -> Bool {
        if(UserDefaults.standard.object(forKey: key) == nil) {
            return false
        }
        return true
    }
    
    // MARK: - User Login
    func setIsUserLogin(isUserLogin: Bool) {
        setDataToPreference(data: isUserLogin, forKey: USER_LOGIN)
    }
    
    func isUserLogin() -> Bool {
        let isUserLogin = getDataFromPreference(key: USER_LOGIN)
        return isUserLogin == nil ? false: (isUserLogin as! Bool)
    }
    
    //MARK: - User data
    func saveUserData(model: LoginModel)
    {
        setDataToPreference(data: model.toDictionary() as AnyObject, forKey: USER_DATA_KEY)
    }
    
    func getUserData() -> LoginModel
    {
        let Obj = getDataFromPreference(key: USER_DATA_KEY) as? [String: Any] ?? [String: Any]()
        return LoginModel(data: Obj)
    }
    
    func removeUserData()
    {
        removeDataFromPreference(key: USER_DATA_KEY)
    }
}
