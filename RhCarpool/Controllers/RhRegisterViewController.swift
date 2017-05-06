//
//  RhRegisterViewController.swift
//  RhCarpool
//
//  Created by Ravi on 29/04/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import UIKit


class RhRegisterViewController: RhBaseViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var registertButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var zoneTextField: UITextField!
    @IBOutlet weak var downArrow: UIButton!

    var values = ["East", "West", "North", "South"]
    let cellReuseIdentifier = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        self.title = "Sign Up"
        self.registertButton.backgroundColor = UIColor.rhGreen
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    @IBAction func dropDown(_ sender: Any) {
      tableView.isHidden = !tableView.isHidden
        if tableView.isHidden == false {
            downArrow.setBackgroundImage(UIImage(named:"up"), for: .normal)
        } else {
            downArrow.setBackgroundImage(UIImage(named:"down"), for: .normal)
        }
        
    }
    
    // MARK: UITableViewDataSource
    
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
        cell.textLabel?.font = zoneTextField.font
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Row selected, so set textField to relevant value, hide tableView
        // endEditing can trigger some other action according to requirements
        zoneTextField.text = values[indexPath.row]
        tableView.isHidden = true
        downArrow.setBackgroundImage(UIImage(named:"down"), for: .normal)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }

}
