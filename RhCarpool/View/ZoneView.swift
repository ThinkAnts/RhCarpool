//
//  ZoneView.swift
//  RhCarpool
//
//  Created by Ravi on 27/09/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import UIKit

class ZoneView: UIView {
    @IBOutlet weak var zonePicker: UIPickerView!
    var pickerData: [String] = [String]()
    var selectedPickervalue: String?

    // MARK: - mark Singleton Methods
    class func loadFromNib() -> (ZoneView?) {
        if let nib = Bundle.main.loadNibNamed("ZoneView", owner: self, options: nil)?.first as? ZoneView {
            return nib
        }
        return nil
    }

    override func awakeFromNib() {
        self.zonePicker.delegate = self
        self.zonePicker.dataSource = self
        // Input data into the Array:
        pickerData = ["East", "West", "North", "South"]
        let button: UIButton = UIButton(frame: CGRect(x: 150, y: 100, width: 45, height: 45))
        button.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
        button.addTarget(self, action: #selector(selectedDateAction), for: .touchUpInside)
        self.addSubview(button)
    }

    @IBAction func selectedDateAction(sender: UIButton) {
        if selectedPickervalue != nil {
            selectedPickervalue = selectedPickervalue! + " Bangalore zone"
        } else {
            selectedPickervalue = "East" + " Bangalore zone"
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "zoneView"),
                                        object: selectedPickervalue)
    }
}

extension ZoneView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPickervalue = pickerData[row]
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int,
                    forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.foregroundColor:
                                                                        UIColor.white])
        return myTitle
    }
}
