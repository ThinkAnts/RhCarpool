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
                UserDefaults.storeUid(uid: uid)
                completion("Success")
            } else {
                let errorString = error?.localizedDescription ?? "Error In Saving User to DataBase"
                completion(errorString)
            }
        }
    }

    func createNewCarPool(carPool: [String: String], carPoolId: String,
                          completion: @escaping (_ success: String) -> Void) {
        let userRef = ref.child("data/carpool").child(carPoolId)
        userRef.setValue(carPool) {(error, _) in
            if error == nil {
                completion("Success")
            } else {
                let errorString = error?.localizedDescription ?? "Error In creating newcar pool to DataBase"
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
                UserDefaults.storeUid(uid: lUsers.uidString)
            }
        }
    }

    func updateUserData(user: [String: String], uidValue: String) {
        let userRef = ref.child("data/users").child(uidValue)
        userRef.updateChildValues(user, withCompletionBlock: {[weak self] (error, _) in
            if error != nil {
                print(error.debugDescription)
            } else {
                DispatchQueue.global(qos: .background).async {
                    self?.getUserData(uid: uidValue)
                }
            }
        })
    }

    func addNewNode(childName: String, uid: String, nodeName: String, newValue: String) {
        ref.child(childName).child(uid).updateChildValues([nodeName: newValue]) { [weak self] (error, _) in
            if error != nil {
                print(error.debugDescription)
            } else {
                DispatchQueue.global(qos: .background).async {
                    self?.getUserData(uid: uid)
                }
            }
        }
    }

    /*FIREBASE VALUE_EVENT_LISTENER */
    func getModelFromFirebase(uid: String) {
        let userRef = ref.child("data/carpool")
//        userRef.observeSingleEvent(of: .value) {(snapShot) in
//            if let jsonData = snapShot.value as? [String: Any] {
//                var lUsers: UserDetails = Mapper<UserDetails>().map(JSON: jsonData)!
//                lUsers.uidString = uid
//                UserDefaults.storeUserData(user: lUsers)
//                UserDefaults.storeUid(uid: lUsers.uidString)
//            }
//        }
        userRef.queryOrdered(byChild: uid).observe(.childAdded, with: { snapshot in
            let jsonData = snapshot.value as? [String: Any]
            print(jsonData as Any)
            })
    }
}
