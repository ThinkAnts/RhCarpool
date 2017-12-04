//
//  RhCreateNewCarPoolController.swift
//  RhCarpool
//
//  Created by Ravi on 30/04/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import UIKit

class RhCreateNewCarPoolController: RhBaseViewController {

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var runningLocationTextField: UITextField!
    @IBOutlet weak var seatsTextField: UITextField!
    @IBOutlet weak var startingLocation: UITextField!
    @IBOutlet weak var dateTimeField: UILabel!
    @IBOutlet weak var routeTextView: UITextView!
    @IBOutlet weak var commentsTextView: UITextView!

    var isDatePickerViewAdded = false
    var datePickerView: RhDatePicker?
    var isPickerViewAdded = false
    var zonePickerView: ZoneView?
    var userDetails: UserDetails?
    var timeStamp = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createButton.backgroundColor = UIColor.rhGreen
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(RhBaseViewController.handleSingleTap))
        view.addGestureRecognizer(tapRecognizer)
        self.addGestures()
    }

    override func viewWillAppear(_ animated: Bool) {
        setup(title:"New CarPool")
        loadProfileData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func addGestures() {
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(RhCreateNewCarPoolController.handleDateTap))
        dateTimeField.addGestureRecognizer(tapRecognizer)
    }

    func loadProfileData() {
        guard let user = UserDefaults.getUserData() else {
            return
        }
        userDetails = user
    }

    func loadDatePickerView() {
        if !isDatePickerViewAdded {
            datePickerView = RhDatePicker.loadDatePcikerNib()
            datePickerView?.center = CGPoint(x: view.bounds.midX,
                                             y: view.bounds.midY)
            datePickerView?.layer.shadowColor = UIColor.darkGray.cgColor
            datePickerView?.layer.shadowRadius = 5.0
            datePickerView?.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
            datePickerView?.layer.shadowOpacity = 1.0
            datePickerView?.clipsToBounds = false
            datePickerView?.tag = 0011
            datePickerView?.layer.masksToBounds = false
            self.view.addSubview(datePickerView!)
            NotificationCenter.default.addObserver(self, selector: #selector(RhCreateNewCarPoolController.datePickerAction),
                                                   name: NSNotification.Name(rawValue: "datePickerView"), object: nil)
        }
    }
    
    @objc func datePickerAction(notification: NSNotification) {
        guard let dateObject = notification.object as? [String] else {
            return
        }
        print(dateObject as Any)
        if dateObject[1] != "" {
            dateTimeField.text = dateObject[1]
            dateTimeField.textColor = UIColor.black
        }
        timeStamp = dateObject[0]
        closeDatePickerView()
    }
    
    func closeDatePickerView() {
        isDatePickerViewAdded = false
        self.view.backgroundColor = UIColor.white
        for view in self.view.subviews where view.tag == 0011 {
            view.removeFromSuperview()
        }
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "datePickerView"), object: nil)
    }

    @objc func handleDateTap() {
        self.view.endEditing(true)
        loadDatePickerView()
        isDatePickerViewAdded = true
    }

    func close() {
        cancelAction()
    }

    @IBAction func createNewCarPool(_ sender: Any) {
        guard validateAllFields() else {
            showAlertViewController(message: "All Fields are Mandatory")
            return
        }
        let carPoolDict: [String: String] = [RhConstants.runningLocation: runningLocationTextField.text ?? "",
                                          RhConstants.noOfSeats: seatsTextField.text ?? "",
                                          RhConstants.direction: userDetails?.direction ?? "",
                                          RhConstants.comments: commentsTextView.text ?? "",
                                          RhConstants.route: routeTextView.text ?? "",
                                          RhConstants.startingLocation: startingLocation.text ?? "",
                                          RhConstants.runningProgram: userDetails?.runningProgram ?? "",
                                          RhConstants.uidString: UserDefaults.getUid() ,
                                          RhConstants.fullName: userDetails?.fullName ?? "",
                                          RhConstants.photoUrl: userDetails?.photoUrl ?? "",
                                          RhConstants.dateAndTime: timeStamp]
        createNewCarPool(carPoolData: carPoolDict, carPoolId: randomString()) { [weak self] response in
            if response == "Success" {
                print(response)
                self?.close()
            } else {
                self?.showAlertViewController(message: response)
            }
        }
    }

    func validateAllFields() -> Bool {
        if seatsTextField.text != "", dateTimeField.text != "",
            runningLocationTextField.text != "", seatsTextField.text != "", startingLocation.text != "" {
            return true
        } else {
            return false
        }
    }
}
extension RhCreateNewCarPoolController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
            if isDatePickerViewAdded == true {
                closeDatePickerView()
            }
    }
}

extension RhCreateNewCarPoolController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Route" || textView.text == "Comments" {
            textView.text = ""
        }
        textView.textColor = UIColor.black
        self.view.frame.origin.y = self.view.frame.origin.y - 216.0
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.tag == 2, textView.text == "" {
            textView.text = "Route"
            textView.textColor = UIColor.lightGray
        } else if textView.tag == 4, textView.text == "" {
            textView.text = "Comments"
            textView.textColor = UIColor.lightGray
        }
        self.view.frame.origin.y = 0.0
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
