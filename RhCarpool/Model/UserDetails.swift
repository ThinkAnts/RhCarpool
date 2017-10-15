//
//  UserDetails.swift
//  RhCarpool
//
//  Created by Ravi on 17/09/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation

class UserDetails: FIRDataObject {
    var fullName: String = ""
    var email: String = ""
    var password: String = ""
    var mobileNumber: String = ""
    var uidString: String = ""
    var direction: String = ""
}
