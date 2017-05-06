//
//  RhWebViewController.swift
//  RhCarpool
//
//  Created by Ravi on 01/05/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import UIKit

class RhWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "About"
        navigationController?.navigationBar.barTintColor = UIColor.backGroundColor
        self.view.backgroundColor = UIColor.backGroundColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.rhGreen]
        self.automaticallyAdjustsScrollViewInsets = false
        let url = URL(string: "http://www.runnershigh.in/")
        let requestObj = URLRequest(url: url!)
        webView.loadRequest(requestObj)
    }

}
