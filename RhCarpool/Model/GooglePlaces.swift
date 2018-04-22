//
//  GooglePlaces.swift
//  RhCarpool
//
//  Created by Ravi on 21/04/18.
//  Copyright © 2018 ThinkAnts. All rights reserved.
//

import Foundation
import ObjectMapper

class GooglePlaces: Mappable {
    var placeResults: [PlaceResults]?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        placeResults <- map["results"]
    }
}

class PlaceResults: Mappable {
    var address: String?
    var name: String?
    var latitude: Double?
    var longitude: Double?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        address <- map["formatted_address"]
        name <- map["name"]
        longitude <- map["geometry.location.lng"]
        latitude <- map["geometry.location.lat"]
    }
}
