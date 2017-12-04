//
//  UserDefaults.swift
//  RhCarpool
//
//  Created by Ravi on 28/09/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import ObjectMapper

extension UserDefaults {
    class func storeUserData(user: UserDetails) {
        let JSONString = Mapper().toJSONString(user, prettyPrint: true)
        let defaults = UserDefaults.standard
        defaults.set(JSONString, forKey: "userData")
    }

    class func getUserData () -> UserDetails? {
        let defaults = UserDefaults.standard
        if let userInfo = defaults.string(forKey: "userData") {
            if let userDetails = UserDetails(JSONString: userInfo) {
                return userDetails
            }
        }
        return nil
    }

    class func storeUid (uid: String) {
        let defaults = UserDefaults.standard
        defaults.set(uid, forKey: "uid")
    }

    class func getUid () -> String! {
        let defaults = UserDefaults.standard
        if let uidString = defaults.string(forKey: "uid") {
            return uidString
        }
        return ""
    }

    class func storeProfileUrl (url: String) {
        let defaults = UserDefaults.standard
        defaults.set(url, forKey: "profileUrl")
    }

    class func getProfileUrl () -> String! {
        let defaults = UserDefaults.standard
        if let profileUrl = defaults.string(forKey: "profileUrl") {
            return profileUrl
        }
        return ""
    }
}
