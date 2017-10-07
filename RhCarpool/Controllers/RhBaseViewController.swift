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

    // MARK: - UIAlert View
    func showAlertViewController(message: String) {
        if message.characters.count == 0 {
            return
        }
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
