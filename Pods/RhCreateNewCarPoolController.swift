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
        self.createButton.backgroundColor = UIColor.rhGreen
    }

    override func viewWillAppear(_ animated: Bool) {
        setup(title:"New CarPool")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
