//
//  ViewController.swift
//  RhCarpool
//
//  Created by Ravi on 16/04/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: RhBaseViewController {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.forgotPassword.setTitleColor(UIColor.rhGreen, for: .normal)
        self.registerButton.setTitleColor(UIColor.rhGreen, for: .normal)
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(RhBaseViewController.handleSingleTap))
        view.addGestureRecognizer(tapRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func forgotPasswordAction(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "forgotvc")
                                                              as? RhForgotPasswordController else {
            return
        }
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }

    @IBAction func registerAction(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "register")
                                                                 as? RhRegisterViewController else {
             return
        }
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }

    @IBAction func signInAction(_ sender: Any) {
        guard validateAllFields() else {
            return
        }
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "home")
                                                                as? RhHomeViewController else {
            return
        }
        if let email = emailTextField.text, let password = passwordTextField.text {
            RhSVProgressHUD.showIndicator(status: "VALIDATING")
            Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] (user, error) in
                if user != nil {
                    FireBaseDataBase.sharedInstance.getUserData(uid: (user?.uid)!)
                    RhSVProgressHUD.hideIndicator()
                    self?.navigationController?.pushViewController(vc, animated: true)
                } else {
                    // Error Block
                    RhSVProgressHUD.hideIndicator()
                    self?.showAlertViewController(message: "Invalid Credentials")
                    print(error?.localizedDescription ?? "Error Occured")
                }
            })
        }
    }

    //Mark:  - Validations
    func validateAllFields() -> Bool {
        if emailTextField.text != "", passwordTextField.text != "" {
            return true
        } else {
            return false
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
