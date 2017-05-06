//
//  ViewController.swift
//  RhCarpool
//
//  Created by Ravi on 16/04/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var registerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.backGroundColor
        self.signInButton.backgroundColor = UIColor.rhGreen
        //self.signInButton.layer.cornerRadius = 8.0
        self.forgotPassword.setTitleColor(UIColor.linkBlue, for: .normal)
        self.registerButton.setTitleColor(UIColor.linkBlue, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func forgotPasswordAction(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "forgotvc")
                                                              as? RhForgotPasswordController else {
            return
        }
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }

    @IBAction func registerAction(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "register")
                                                                 as? RhRegisterViewController else {
             return
        }
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }

    @IBAction func signInAction(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "home")
                                                                as? RhHomeViewController else {
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
