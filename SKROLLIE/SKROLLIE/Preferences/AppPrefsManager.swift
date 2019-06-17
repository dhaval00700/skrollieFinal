//
//  AppPrefsManager.swift
//  Trustfund
//
//  Created by Smit Patel on 19/03/19.
//  Copyright © 2019 Smit Patel. All rights reserved.
//

import Foundation

class AppPrefsManager {
    static let shared = AppPrefsManager()
    
    
    private let FCM_TOKEN = "FCM_TOKEN"
    private let DEVICE_ID = "DEVICE_ID"
    private let WALKTHROUGH_SHOWN = "WALKTHROUGH_SHOWN"
    private let USER_ID = "USER_ID"
    private let SET_PIN = "SET_PIN"
    private let USER_LOGIN  =   "USER_LOGIN"
    private let SESSION_ID  =   "SID"
    
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
    
    // MARK: - FCM Token
    func setFCMToken(token: String) {
        setDataToPreference(data: token, forKey: FCM_TOKEN)
    }
    
    func getFCMToken() -> String {
        return getDataFromPreference(key: FCM_TOKEN) as? String ?? ""
    }
    
    // MARK: - Device ID
    func setDeviceId(id: String) {
        setDataToPreference(data: id, forKey: DEVICE_ID)
    }
    
    func getDeviceId() -> String {
        return getDataFromPreference(key: DEVICE_ID) as! String
    }
    
    // MARK: - Walkthrough Shown
    func setIsWalkthroughShown(shown: Bool) {
        setDataToPreference(data: shown, forKey: WALKTHROUGH_SHOWN)
    }
    
    func isWalkthroughShown() -> Bool {
        let shown = getDataFromPreference(key: WALKTHROUGH_SHOWN)
        return shown == nil ? false: (shown as! Bool)
    }
    
    // MARK: - User Login
    func setIsUserLogin(isUserLogin: Bool) {
        setDataToPreference(data: isUserLogin, forKey: USER_LOGIN)
    }
    
    func isUserLogin() -> Bool {
        let isUserLogin = getDataFromPreference(key: USER_LOGIN)
        return isUserLogin == nil ? false: (isUserLogin as! Bool)
    }
}
