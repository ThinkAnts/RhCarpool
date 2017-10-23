//
//  RhForgotPasswordController.swift
//  RhCarpool
//
//  Created by Ravi on 28/04/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import UIKit

class RhForgotPasswordController: RhBaseViewController {
     @IBOutlet weak var resetButton: UIButton!
     @IBOutlet weak var emailTextField: UITextField!
     @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup(title: "Forgot Password")
        self.resetButton.backgroundColor = UIColor.rhGreen
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(RhBaseViewController.handleSingleTap))
        view.addGestureRecognizer(tapRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        errorLabel.isHidden = true
    }

    @IBAction func resetPasswordAction(_ sender: UIButton) {
        let emailString  = emailTextField.text ?? ""
        guard validateAllFields(email: emailString) else {
            displayError(message: "Please enter email address")
            return
        }
        guard isValidEmail(email: emailString) else {
            displayError(message: "Please enter a valid email address")
            return
        }
        errorLabel.isHidden = true
        resetePassword(email: emailString) {[weak self] response in
            if response == "Success" {
                self?.backToPreviousScreen()
            } else {
                if response.contains("no user record") {
                    self?.displayError(message: "No User found matching this email address")
                } else {
                    self?.showAlertViewController(message: response)
                }
            }
        }
    }

    func displayError(message: String) {
        errorLabel.isHidden = false
        errorLabel.text = message
    }
    func backToPreviousScreen() {
        cancelAction()
    }

    //Mark:  - Validations
    func validateAllFields(email: String) -> Bool {
        if email != "" {
            return true
        } else {
            return false
        }
    }

    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}

extension RhForgotPasswordController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
