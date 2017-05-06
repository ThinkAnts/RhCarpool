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
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.createButton.backgroundColor = UIColor.rhGreen
        self.title = "New CarPool"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
