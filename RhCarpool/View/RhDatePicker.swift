//
//  RhDatePicker.swift
//  RhCarpool
//
//  Created by Ravi on 30/10/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import UIKit

class RhDatePicker: UIView {
    @IBOutlet weak var datePicker: UIDatePicker!

    // MARK: - mark Singleton Methods
    class func loadDatePcikerNib() -> (RhDatePicker?) {
        if let nib = Bundle.main.loadNibNamed("RhDatePicker", owner: self, options: nil)?.first as? RhDatePicker {
            return nib
        }
        return nil
    }

    override func awakeFromNib() {
        // Input data into the Array:
        let button: UIButton = UIButton(frame: CGRect(x: 150, y: 140, width: 45, height: 45))
        button.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
        button.addTarget(self, action: #selector(selectedDateAction), for: .touchUpInside)
        self.addSubview(button)
    }

    @IBAction func selectedDateAction(sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        let dateString = dateFormatter.string(from: datePicker.date)
        let timeStamp = NSNumber(value: datePicker.date.timeIntervalSince1970)
        let numberFormat = NumberFormatter()
        let timeStampString = numberFormat.string(from: timeStamp)
        print(dateString)
        var dateObject = [String]()
        dateObject.append(timeStampString!)
        dateObject.append(dateString)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "datePickerView"),
                                        object: dateObject)
    }
}
