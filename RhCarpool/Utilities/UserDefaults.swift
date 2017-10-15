//
//  UserDefaults.swift
//  RhCarpool
//
//  Created by Ravi on 28/09/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation

extension UserDefaults {

    class func storeAuthToken (authToken: String) {
        let defaults = UserDefaults.standard
        defaults.set(authToken, forKey: "authToken")
    }

    class func getAuthToken () -> String? {
        let defaults = UserDefaults.standard
        if let authTokenString = defaults.string(forKey: "authToken") {
            return authTokenString
        }
        return ""
    }

    class func storeUserData(user: UserDetails) {
        let defaults = UserDefaults.standard
        defaults.set(user, forKey: "userData")
    }

    class func getUserData () -> [UserDetails]? {
        let defaults = UserDefaults.standard
        if let user = defaults.object(forKey: "userData") as? [UserDetails] {
            return user
        }
        return nil
    }
}
