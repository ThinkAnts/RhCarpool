//
//  GoogleMapsSDKManager.swift
//  RhCarpool
//
//  Created by Ravi on 21/04/18.
//  Copyright © 2018 ThinkAnts. All rights reserved.
//

import Foundation
import GoogleMaps
import Alamofire
import ObjectMapper

class GoogleMapsSDKManager: NSObject {
    static func getAddressForCoOrdinatesUsingGoogleMaps(latLong: CLLocation,
                                                        completionHandler: @escaping (String?, String?) -> Void) {
        let aGMSGeocoder = GMSGeocoder()
        aGMSGeocoder.reverseGeocodeCoordinate(latLong.coordinate) { response, error in
            if let location = response?.firstResult() {
                print(location)
                if error != nil {
                    completionHandler(nil, error?.localizedDescription)
                } else {
                    if location.locality != nil && location.subLocality != nil {
                        completionHandler(location.subLocality, nil)
                    } else if location.subLocality != nil {
                        completionHandler(location.subLocality, nil)
                    } else if location.locality != nil {
                        completionHandler(location.locality, nil)
                    } else {
                        completionHandler("Location Name", nil)
                    }
                }
            }
        }
    }
    static func searchPlacesUsingGoogleAPIWithCoordinate(location: CLLocation, radius: Int,
                                                         searchText: String,
                                                         completionHandler: @escaping([PlaceResults]?,
                                                        String?) -> Void) {
        let encodeSearchText = searchText.addingPercentEncoding(withAllowedCharacters:.urlPathAllowed) ?? searchText
        Alamofire.request(preparePlaceSearchAPI(encodeSearchText, location), method: .get, parameters: ["": ""],
                          encoding: URLEncoding.default, headers: nil).responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success(_):
                if response.result.value != nil {
                    let jsonString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)! as String
                    if let clubs = Mapper<GooglePlaces>().map(JSONString: jsonString) {
                        completionHandler(clubs.placeResults, nil)
                    } else {
                        completionHandler(nil, "Request failed !")
                    }
                } else {
                    completionHandler(nil, "Request failed !")
                }
                break
            case .failure(_):
                print(response.result.error ?? "")
                completionHandler(nil, response.result.error?.localizedDescription)
                break
            }
        }
    }
    static func preparePlaceSearchAPI(_ textSearch: String, _ location: CLLocation) -> String {
        var gmsAPIPlaceSearch  = ""
        let googleUrl = "https://maps.googleapis.com/maps/api/place/textsearch/"
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        let radius = RhConstants.gmsPlaceSearchRadius
        let key = RhConstants.gmsAPIKey
        if location.coordinate.latitude == 0.0 && location.coordinate.longitude == 0.0 {
            gmsAPIPlaceSearch = "\(googleUrl)json?query=\(textSearch)&key=\(key)"
            return gmsAPIPlaceSearch
        }
        gmsAPIPlaceSearch = "\(googleUrl)json?query=\(textSearch)&location=\(lat),\(lon)&radius=\(radius)&key=\(key)"
        return gmsAPIPlaceSearch
    }
}
