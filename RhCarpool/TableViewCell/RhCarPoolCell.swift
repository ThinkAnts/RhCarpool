//
//  RhCarPoolCell.swift
//  RhCarpool
//
//  Created by Ravi on 30/04/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import UIKit


class RhCarPoolCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var seat: UILabel!
    @IBOutlet weak var route: UILabel!
    @IBOutlet weak var startTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
