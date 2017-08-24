//
//  RhRegisterViewController.swift
//  RhCarpool
//
//  Created by Ravi on 29/04/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import UIKit

class RhRegisterViewController: RhBaseViewController, UIPickerViewDataSource, UIPickerViewDelegate,
                                UITextFieldDelegate {
    @IBOutlet weak var registertButton: UIButton!
    @IBOutlet weak var zoneTextField: UITextField! { didSet { zoneTextField.delegate = self } }
    @IBOutlet weak var pickerView: UIPickerView!

    var pickerDataSoruce = ["East", "West", "North", "South"]
    let cellReuseIdentifier = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.title = "Sign Up"
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.registertButton.backgroundColor = UIColor.rhGreen
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

    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        self.pickerView.isHidden = false
    }
}
