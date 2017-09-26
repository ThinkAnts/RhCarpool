//
//  RhWebViewController.swift
//  RhCarpool
//
//  Created by Ravi on 01/05/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import UIKit

class RhWebViewController: RhBaseViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        setup(title:"About")
        let url = URL(string: "http://www.runnershigh.in/")
        let requestObj = URLRequest(url: url!)
        webView.loadRequest(requestObj)
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate), style: UIBarButtonItemStyle.plain,
                                         target: self, action: #selector(RhWebViewController.goBack))
        self.navigationItem.leftBarButtonItem = backButton
    }

    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
