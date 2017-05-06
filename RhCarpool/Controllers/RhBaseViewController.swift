//
//  RhBaseViewController.swift
//  RhCarpool
//
//  Created by Ravi on 30/04/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import UIKit


class RhBaseViewController: UIViewController {
    
    func setup() {
        navigationController?.navigationBar.barTintColor = UIColor.backGroundColor
        self.view.backgroundColor = UIColor.backGroundColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.rhGreen]
        let backButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RhBaseViewController.cancelAction))
        self.navigationItem.leftBarButtonItem = backButton
        self.automaticallyAdjustsScrollViewInsets = false
        //self.createButton.layer.cornerRadius = 8.0
    }
    
    func cancelAction() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
