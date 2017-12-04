//
//  CarPoolDetails.swift
//  RhCarpool
//
//  Created by Ravi on 25/11/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import ObjectMapper

struct CarPoolDetails: Mappable {
    var runningLocation: String = ""
    var noOfSeats: String = ""
    var dateAndTime: String = ""
    var startingLocation: String = ""
    var route: String = ""
    var comments: String = ""
    var runningProgram: String = ""
    var uid: String = ""
    var direction: String = ""
    var fullName: String = ""
    var photoUrl: String = ""

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        runningLocation   <- map["runningLocation"]
        dateAndTime      <- map["dateAndTime"]
        noOfSeats   <- map["noOfSeats"]
        route  <- map["route"]
        comments     <- map["comments"]
        direction     <- map["direction"]
        startingLocation <- map["startingLocation"]
        uid  <- map["uid"]
        runningProgram  <- map["runningProgram"]
        fullName <- map["fullName"]
        photoUrl <- map["photoUrl"]
    }
}
