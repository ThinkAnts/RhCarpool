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
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!

    var pickerDataSoruce = ["East", "West", "North", "South"]
    let cellReuseIdentifier = "cell"
    var isPickerViewAdded = false
    var zonePickerView: ZoneView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup(title: "Create Account")
        //self.pickerView.dataSource = self
        //self.pickerView.delegate = self
        self.registertButton.backgroundColor = UIColor.rhGreen
    }

    override func viewWillAppear(_ animated: Bool) {
        zoneTextField.inputView = UIView()
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
        let userDict: [String: String] = [RhConstants.emailAddress: emailTextField.text ?? "",
                        RhConstants.password: passwordTextField.text ?? "",
                        RhConstants.fullName: nameTextField.text ?? "",
                        RhConstants.mobileNumber: mobileTextField.text ?? "",
                        RhConstants.direction: zoneTextField.text ?? ""]
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

    func loadPickerView() {
        if !isPickerViewAdded {
            zonePickerView = ZoneView.loadFromNib()
            zonePickerView?.center = CGPoint(x: view.bounds.midX,
                                      y: view.bounds.midY)
            zonePickerView?.layer.shadowColor = UIColor.darkGray.cgColor
            zonePickerView?.layer.shadowRadius = 5.0
            zonePickerView?.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
            zonePickerView?.layer.shadowOpacity = 1.0
            zonePickerView?.clipsToBounds = false
            zonePickerView?.tag = 0001
            zonePickerView?.layer.masksToBounds = false
            self.view.addSubview(zonePickerView!)
            self.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            NotificationCenter.default.addObserver(self, selector: #selector(RhRegisterViewController.doneAction),
                                                   name: NSNotification.Name(rawValue: "zoneView"), object: nil)
        }
    }

    @objc func doneAction(notification: NSNotification) {
        let selectedZone = notification.object as? String
        if selectedZone != "" {
            zoneTextField.text = selectedZone ?? ""
        }
        closeDOBView()
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "zoneView"), object: nil)
    }

    func closeDOBView() {
        isPickerViewAdded = false
        self.view.backgroundColor = UIColor.white
        for view in self.view.subviews where view.tag == 0001 {
            view.removeFromSuperview()
        }
    }
}

extension RhRegisterViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 111 {
            textField.resignFirstResponder()
            loadPickerView()
            isPickerViewAdded = true
        }
    }
}
