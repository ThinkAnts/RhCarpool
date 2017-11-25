//
//  RhHomeViewControllrt.swift
//  RhCarpool
//
//  Created by Ravi on 30/04/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import UIKit

class RhHomeViewController: RhBaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var carPoolTableView: UITableView!
    override func viewDidLoad() {
        carPoolTableView.register(UINib(nibName: "RhCarpoolCell", bundle: nil), forCellReuseIdentifier: "carpool")
        let user = UserDefaults.getUserData()
        let uidString = UserDefaults.getUid()!
        if uidString == "" {
            UserDefaults.storeUid(uid: user?.uidString ?? "")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        setup(title: "RH CarPool")
        loadInitialView()
        FireBaseDataBase.sharedInstance.getModelFromFirebase(uid: UserDefaults.getUserData()?.uidString ?? "")
    }

    func loadInitialView() {
        self.navigationController?.navigationItem.hidesBackButton = true
        let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings").withRenderingMode(.alwaysOriginal),
                                             style:  UIBarButtonItemStyle.plain,
                                             target: self, action: #selector(RhHomeViewController.settingsAction))
        self.navigationItem.leftBarButtonItem = settingsButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "add").withRenderingMode(.alwaysOriginal),
                                        style: UIBarButtonItemStyle.plain,
                                        target: self, action: #selector(RhHomeViewController.addAction))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
    }
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int = 0
        if section == 0 {
            count = 2
        } else if section == 1 {
           count = 3
        }
       return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let carPoolCell = (tableView.dequeueReusableCell(withIdentifier: "carpool") as? RhCarPoolCell)!
        return carPoolCell
    }

    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Row selected, so set textField to relevant value, hide tableView
        // endEditing can trigger some other action according to requirements
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel(frame: CGRect(x: 10, y: 8, width: tableView.frame.size.width, height: 18))
        if section == 0 {
            label.text = "RH's Ride"
        } else {
            label.text = "My Ride"
        }
        label.textColor = UIColor.white
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        view.addSubview(label)
        view.backgroundColor = UIColor.rhGreen // Set your background color
        return view
    }

    @objc func addAction() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "newcarpool")
                                                            as? RhCreateNewCarPoolController else {
            return
        }
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }

    @objc func settingsAction() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "settings")
                                                                 as? RhSettingsViewController else {
              return
        }
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
}
