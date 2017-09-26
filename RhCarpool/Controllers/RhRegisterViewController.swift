//
//  RhRegisterViewController.swift
//  RhCarpool
//
//  Created by Ravi on 29/04/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import UIKit

class RhRegisterViewController: RhBaseViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var registertButton: UIButton!
    @IBOutlet weak var zoneTextField: UITextField! { didSet { zoneTextField.delegate = self } }
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!

    var pickerDataSoruce = ["East", "West", "North", "South"]
    let cellReuseIdentifier = "cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        setup(title: "Sign Up")
        //self.pickerView.dataSource = self
        //self.pickerView.delegate = self
        self.registertButton.backgroundColor = UIColor.rhGreen
    }

    override func viewWillAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //Mark: Picker Data Source Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSoruce.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSoruce[row]
    }

    @IBAction func registerNewUser(_ sender: UIButton) {
        guard validateAllFields() else {
            showAlertViewController(message: "All Fields are Mandatory")
            return
        }
        let userDict: [String: String] = [RhConstants.emailAddress: emailTextField.text!,
                        RhConstants.password: passwordTextField.text!,
                        RhConstants.fullName: fullNameTextField.text!,
                        RhConstants.mobileNumber: mobileTextField.text!, RhConstants.direction: zoneTextField.text!]
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
            fullNameTextField.text != "",
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
