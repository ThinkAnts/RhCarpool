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
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var noOfSeats: UILabel!
    @IBOutlet weak var mobileNumberButton: UIButton!

    override func layoutSubviews() {
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        let shadowPath = UIBezierPath(rect: mainView.bounds)
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.rhGreen.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3
        self.layer.shadowPath = shadowPath.cgPath
        super.layoutSubviews()
    }

    func setupData(carPoolDetail: CarPoolDetails) {
        nameLabel.text = carPoolDetail.fullName
        routeLabel.text = carPoolDetail.startingLocation + " to " + carPoolDetail.runningLocation
        dateTime.text = carPoolDetail.dateAndTime
        noOfSeats.text = carPoolDetail.noOfSeats + " Seats available"
        if carPoolDetail.runnersMobileNumber != "" {
            mobileNumberButton.isHidden = false
            mobileNumberButton.setTitle("+91 " + carPoolDetail.runnersMobileNumber, for: .normal)
        } else {
            mobileNumberButton.isHidden = true
        }
    }
}
