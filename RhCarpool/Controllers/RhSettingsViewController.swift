//
//  RhSettingsViewController.swift
//  RhCarpool
//
//  Created by Ravi on 30/04/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import UIKit

class RhSettingsViewController: RhBaseViewController {

    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!

    var values = ["About", "Account", "Notifications"]
    let cellReuseIdentifier = "cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.logoutButton.backgroundColor = UIColor.rhGreen
    }

    override func viewWillAppear(_ animated: Bool) {
        setup(title:"Settings")
    }

       @IBAction func logout(_ sender: Any) {
        let error = signOut()
        if error == "" {
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "login")
            UIApplication.shared.keyWindow?.rootViewController = loginViewController
            clearUserDefaults()
        } else {
            showAlertViewController(message: "Error In Singing Out of Application")
       }
     }
}

extension RhSettingsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
        // Set text from the data model
        cell.textLabel?.text = values[indexPath.row]
        cell.textLabel?.font = UIFont(name: "avenir next", size: 14)
        if indexPath.row == 2 {
            let switchView = UISwitch(frame: CGRect.zero)
            cell.accessoryView = switchView
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Row selected, so set textField to relevant value, hide tableView
        // endEditing can trigger some other action according to requirements
        if indexPath.row == 0 {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "webview")
                as? RhWebViewController else {
                    return
            }
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "profile")
                as? RhProfileViewController else {
                    return
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
}
