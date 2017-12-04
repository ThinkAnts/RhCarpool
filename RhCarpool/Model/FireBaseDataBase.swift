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
    //var userData: [UserDetails] = []
    let workDone = DispatchGroup()
    fileprivate var carPoolArray = [CarPoolDetails]()
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
    func getModelFromFirebase(timeStamp: String,
                              completion: @escaping (_ success: String, _ carPoolArrayData: [CarPoolDetails]) -> Void) {
        let carRef = ref.child("data/carpool")
        carRef.queryOrdered(byChild: "dateAndTime").queryStarting(atValue: timeStamp)
              .observeSingleEvent(of: .value, with: {[weak self] snapshot in
            let enumerator = snapshot.children
                if self?.carPoolArray.count != 0 {
                    self?.carPoolArray.removeAll()  //clear old values before adding
                }
            while let requiredValue = enumerator.nextObject() as? DataSnapshot {
                guard let jsonData = requiredValue.value  as? [String: Any] else {
                   return completion("Failed To Data", self?.carPoolArray ?? [CarPoolDetails]())
                }
                guard let carPoolDetails: CarPoolDetails = Mapper<CarPoolDetails>().map(JSON: jsonData) else {
                  return completion("No Data present", self?.carPoolArray ?? [CarPoolDetails]())
                }
                self?.carPoolArray.append(carPoolDetails)
            }
            completion("Success", self?.carPoolArray ?? [CarPoolDetails]())
        })
    }

    func getCarPoolDetails(timeStamp: String,
                           completion: @escaping (_ success: String, _ carPoolArrayData: [CarPoolDetails]) -> Void) {

        self.checkIfChildExists(ref: ref.child("data"), path: "carpool") { [weak self] (response) in
            if response == "Success" {
                DispatchQueue.main.async {
                    self?.getModelFromFirebase(timeStamp: timeStamp, completion: { (response, carPoolData) in
                        completion(response, carPoolData)
                    })
                }
            } else {
                completion(response, self?.carPoolArray ?? [CarPoolDetails]())
            }
        }
    }

    func checkIfChildExists(ref: DatabaseReference, path: String, completion: @escaping (_ success: String) -> Void) {
        ref.observeSingleEvent(of: .value) { (snapShot) in
            if snapShot.hasChild(path) {
                completion("Success")
            } else {
                completion("No Data Present")
            }
        }
    }

    func updateCarpoolData(profileUrl: String, uid: String, timeStamp: String) {
        let poolRef = ref.child("data/carpool")
        poolRef.queryOrdered(byChild: "uid").queryStarting(atValue: timeStamp)
                                            .queryEnding(atValue: uid)
                                            .observeSingleEvent(of: .value) {(snapShot) in
            let enumartor = snapShot.children
            while let reqValue = enumartor.nextObject() as? DataSnapshot {
               poolRef.child(reqValue.key).updateChildValues(["photoUrl": profileUrl])
            }
        }

    }
}
