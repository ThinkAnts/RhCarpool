//
//  UserDetails.swift
//  RhCarpool
//
//  Created by Ravi on 17/09/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserDetails: Mappable {
    var fullName: String = ""
    var email: String = ""
    var password: String = ""
    var mobileNumber: String = ""
    var uidString: String = ""
    var direction: String = ""
    var authToken: String = ""
    var photoUrl: String = ""
    var runningProgram: String = ""

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        fullName   <- map["fullName"]
        email      <- map["email"]
        password   <- map["password"]
        mobileNumber  <- map["mobileNumber"]
        uidString     <- map["uidString"]
        direction     <- map["direction"]
        authToken <- map["authToken"]
        photoUrl  <- map["photoUrl"]
        runningProgram  <- map["runningProgram"]
    }
}
