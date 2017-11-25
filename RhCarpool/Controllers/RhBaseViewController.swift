//
//  RhBaseViewController.swift
//  RhCarpool
//
//  Created by Ravi on 30/04/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class RhBaseViewController: UIViewController {
    let regexp = "^(?=.*[a-zA-Z])(?=.*[0-9])"
    var ref: DatabaseReference?
    func setup(title: String) {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:
                                                                    UIColor.black]
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysOriginal), style: UIBarButtonItemStyle.plain,
                                         target: self, action: #selector(RhBaseViewController.cancelAction))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = title
        ref = Database.database().reference()
    }

    @objc func cancelAction() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    // MARK: - SignOut
    func signOut() -> String {
        var returnString = ""
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            returnString = signOutError.localizedDescription
            return returnString
        }
        return returnString
    }

    func clearUserDefaults() {
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
    }
    // MARK: - Firebase API Calls
    func createUser(userData: [String: String], completion: @escaping (_ success: String) -> Void) {
        RhSVProgressHUD.showIndicator(status: "")
        let email = userData[RhConstants.emailAddress] ?? ""
        let password = userData[RhConstants.password] ?? ""
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in
            if user != nil {
                FireBaseDataBase.sharedInstance.registerUser(childName: "data/users",
                                                             user: userData,
                                                             uid: (user?.uid)!, completion: { response in
                    if response == "Success" {
                        completion(response)
                    } else {
                        completion(response)
                    }
                    RhSVProgressHUD.hideIndicator()
                })
            } else {
                // Error: check error
                RhSVProgressHUD.hideIndicator()
                let errorString = error?.localizedDescription ?? "Error In Saving User to DataBase"
                completion(errorString)
            }
        })
    }

    func resetePassword(email: String, completion: @escaping (_ success: String) -> Void) {
        RhSVProgressHUD.showIndicator(status: "")
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            RhSVProgressHUD.hideIndicator()
            if error == nil {
                RhSVProgressHUD.showSuccessMessage(status: "Email Sucessfully Sent", imageString: "tick")
                completion("Success")
            } else {
                let errorString = error?.localizedDescription ?? "Error In Reseting the password"
                completion(errorString)
            }
        }
    }

    func createNewCarPool(carPoolData: [String: String], carPoolId: String,
                          completion: @escaping (_ success: String) -> Void) {
        RhSVProgressHUD.showIndicator(status: "")
        FireBaseDataBase.sharedInstance.createNewCarPool(carPool: carPoolData, carPoolId: carPoolId) { response in
            if response == "Success" {
                completion(response)
                RhSVProgressHUD.showSuccessMessage(status: "CarPool Sucessfully Created", imageString: "tick")
            } else {
                completion(response)
            }
            RhSVProgressHUD.hideIndicator()
        }
    }

    // MARK: - UIAlert View
    func showAlertViewController(message: String) {
        if message.characters.count == 0 {
            return
        }
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Generate Random String
    func randomString() -> String {
        let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< 20 {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }

    @objc func handleSingleTap() {
        self.view.endEditing(true)
    }
}
