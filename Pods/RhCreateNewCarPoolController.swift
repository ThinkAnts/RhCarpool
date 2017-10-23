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
    @IBOutlet weak var dateTimeTextField: UITextField!
    @IBOutlet weak var zoneTextField: UITextField!
    @IBOutlet weak var routeTextView: UITextView!
    @IBOutlet weak var commentsTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createButton.backgroundColor = UIColor.rhGreen
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(RhBaseViewController.handleSingleTap))
        view.addGestureRecognizer(tapRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        setup(title:"New CarPool")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension RhCreateNewCarPoolController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
