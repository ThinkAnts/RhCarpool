//
//  RhCarPoolCell.swift
//  RhCarpool
//
//  Created by Ravi on 30/04/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class RhCarPoolCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var seat: UILabel!
    @IBOutlet weak var route: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.layer.masksToBounds = true
    }

    func setupData(carPoolDetail: CarPoolDetails) {
        self.title.text = carPoolDetail.runningLocation
        self.seat.text = carPoolDetail.noOfSeats + " Seats"
        self.route.text = carPoolDetail.route
        self.startTime.text = stringFromTimeInterval(interval: carPoolDetail.dateAndTime)
        self.name.text = carPoolDetail.fullName
        let photoUrlString = carPoolDetail.photoUrl
        if let profileImageUrl = URL(string: photoUrlString ) {
            profileImage.sd_setImage(with: profileImageUrl, placeholderImage: #imageLiteral(resourceName: "face"))
        }
    }

    func stringFromTimeInterval (interval: String) -> String {
        if let timeInterval = TimeInterval(interval) {
            let date = NSDate(timeIntervalSince1970: TimeInterval(timeInterval))
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
            dateFormatter.timeZone = TimeZone.current
            let localDate = dateFormatter.string(from: date as Date)
            return localDate
        } else {
            return "00:00:00"
        }
    }
}
