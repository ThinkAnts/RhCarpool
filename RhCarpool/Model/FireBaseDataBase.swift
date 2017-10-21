//
//  FireBaseDataBase.swift
//  RhCarpool
//
//  Created by Ravi on 24/09/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper

class FireBaseDataBase: NSObject {
    static let sharedInstance = FireBaseDataBase()
    var userData: [UserDetails] = []
    var ref: DatabaseReference!
    //This prevents others from using the default '()' initializer for this class.
    private override init() {
        ref = Database.database().reference()
    }

    func registerUser(childName: String, user: [String: String], uid: String,
                      completion: @escaping (_ success: String) -> Void) {
        let userRef = ref.child("data/users").child(uid)
        userRef.setValue(user) {(error, _) in
            if error == nil {
                var lUsers: UserDetails = Mapper<UserDetails>().map(JSON: user)!
                lUsers.uidString = uid
                UserDefaults.storeUserData(user: lUsers)
                completion("Success")
            } else {
                let errorString = error?.localizedDescription ?? "Error In Saving User to DataBase"
                completion(errorString)
            }
        }
    }

    func getUserData(uid: String) {
        let userRef = ref.child("data/users").child(uid)
        userRef.observeSingleEvent(of: .value) {(snapShot) in
            if let jsonData = snapShot.value as? [String: Any] {
                var lUsers: UserDetails = Mapper<UserDetails>().map(JSON: jsonData)!
                lUsers.uidString = uid
                UserDefaults.storeUserData(user: lUsers)
            }
        }
    }

    func addNewNode(childName: String, uid: String, nodeName: String, newValue: String) {
        ref.child(childName).child(uid).updateChildValues([nodeName: newValue]) { (error, _) in
            print(error.debugDescription)
        }
    }
}
