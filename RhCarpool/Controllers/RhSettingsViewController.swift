//
//  RhSettingsViewController.swift
//  RhCarpool
//
//  Created by Ravi on 30/04/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import UIKit


class RhSettingsViewController: RhBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    
    var values = ["About", "Account", "Notifications"]
    let cellReuseIdentifier = "cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        setup()
        self.logoutButton.backgroundColor = UIColor.rhGreen
    }
    
    // MARK: UITableViewDataSource & Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
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
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Row selected, so set textField to relevant value, hide tableView
        // endEditing can trigger some other action according to requirements
        if indexPath.row == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "webview") as! RhWebViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "profile") as! RhProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
}
