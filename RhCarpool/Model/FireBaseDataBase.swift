//
//  FireBaseDataBase.swift
//  RhCarpool
//
//  Created by Ravi on 24/09/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import Firebase

class FireBaseDataBase {
    static let sharedInstance = FireBaseDataBase()
    var ref: DatabaseReference!
    //This prevents others from using the default '()' initializer for this class.
    private init() {
        ref = Database.database().reference()
    }

    func registerUser(childName: String, user: [String: String], uid: String,
                      completion: @escaping (_ success: String) -> Void) {
        let userRef = ref.child("data/users").child(uid)
//        let userDict = [RhConstants.emailAddress: user[RhConstants.emailAddress],
//                        RhConstants.fullName: user[RhConstants.fullName],
//                        RhConstants.password: user[RhConstants.password],
//                        RhConstants.mobileNumber: user[RhConstants.mobileNumber],
//                        RhConstants.direction: user[RhConstants.direction]]
        userRef.setValue(user) { (error, _) in
            if error == nil {
                let userDetails = UserDetails()
                userDetails.email = user[RhConstants.emailAddress]!
                userDetails.fullName = user[RhConstants.fullName]!
                userDetails.mobileNumber = user[RhConstants.mobileNumber]!
                userDetails.password = user[RhConstants.password]!
                userDetails.zone = user[RhConstants.direction]!
                completion("Success")
            } else {
                let errorString = error?.localizedDescription ?? "Error In Saving User to DataBase"
                completion(errorString)
            }
        }
    }
}
