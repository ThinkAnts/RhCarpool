//
//  RhRegisterViewController.swift
//  RhCarpool
//
//  Created by Ravi on 29/04/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import UIKit

class RhRegisterViewController: RhBaseViewController {
    @IBOutlet weak var registertButton: UIButton!
    @IBOutlet weak var zoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var runningProgramField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup(title: "Create Account")
        self.registertButton.backgroundColor = UIColor.rhGreen
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(RhBaseViewController.handleSingleTap))
        view.addGestureRecognizer(tapRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func registerNewUser(_ sender: UIButton) {
        guard validateAllFields() else {
            showAlertViewController(message: "All Fields are Mandatory")
            return
        }
        let userDict: [String: String] = [RhConstants.emailAddress: emailTextField.text ?? "",
                        RhConstants.password: passwordTextField.text ?? "",
                        RhConstants.fullName: nameTextField.text ?? "",
                        RhConstants.mobileNumber: mobileTextField.text ?? "",
                        RhConstants.direction: zoneTextField.text ?? "",
                        RhConstants.runningProgram: runningProgramField.text ?? "",
                        RhConstants.authToken: randomString()]
        createUser(userData: userDict) {[weak self] response in
            if response == "Success" {
                self?.backToPreviousScreen()
            } else {
                self?.showAlertViewController(message: response)
            }
        }
    }

    //Mark:  - Validations
    func validateAllFields() -> Bool {
        if emailTextField.text != "", passwordTextField.text != "",
            nameTextField.text != "",
            mobileTextField.text != "", zoneTextField.text != "" {
            return true
        } else {
            return false
        }
    }

    func backToPreviousScreen() {
        cancelAction()
    }
}

extension RhRegisterViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 111 || textField.tag == 9 {
            self.view.frame.origin.y -= 216
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.view.frame.origin.y < 0 {
            self.view.frame.origin.y = 0
        }
    }
}
