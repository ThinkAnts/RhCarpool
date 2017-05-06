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
     @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.title = "Forgot Password"
        self.resetButton.backgroundColor = UIColor.rhGreen
        textView.backgroundColor = UIColor.backGroundColor
    }

}
