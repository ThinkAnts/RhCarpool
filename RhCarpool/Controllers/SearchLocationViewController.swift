//
//  SearchLocationViewController.swift
//  RhCarpool
//
//  Created by Ravi on 21/04/18.
//  Copyright © 2018 ThinkAnts. All rights reserved.
//

import UIKit
import CoreLocation
class SearchLocationViewController: RhBaseViewController {

    @IBOutlet weak var changeLocationTableView: UITableView!
    @IBOutlet var locationSearchBar: UISearchBar!
    var searchResults: [PlaceResults] = []
    let locationTableCellIdentifier = "SearchLocationTableCell"
    let locManager = UserLocationManager.SharedManager
    var locationSelectedHandler: ((_ locationValue: CLLocation, _ address: String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        doNavigationBarDesigns()
        registerTableCellNIB()
        setUpSearchBar()
    }

    func setUpSearchBar() {
        if let searchBarTextField: UITextField = locationSearchBar.value(forKey: "_searchField") as? UITextField {
            searchBarTextField.backgroundColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        }
    }

    func doNavigationBarDesigns() {
        title = "Search Location"
        let searchImage = UIImage.init(named: "iconannotategreen")?.withRenderingMode(.alwaysOriginal)
        let searchButton = UIBarButtonItem(image: searchImage, style: .plain,
                                           target: self, action: #selector(self.searchBarButtonClicked))
        self.navigationItem.rightBarButtonItem  = searchButton
    }

    func showSearchBar(show: Bool) {
        if show {
            navigationController?.navigationBar.isHidden = true
            locationSearchBar.isHidden = false
            locationSearchBar.becomeFirstResponder()
        } else {
            navigationController?.navigationBar.isHidden = false
            locationSearchBar.isHidden = true
            locationSearchBar.resignFirstResponder()
        }
        view.updateConstraintsIfNeeded()
    }

    func registerTableCellNIB () {
        let nib = UINib(nibName: "RhLocationTableViewCell", bundle: nil)
        changeLocationTableView.register(nib, forCellReuseIdentifier: locationTableCellIdentifier)
    }

    @objc func searchBarButtonClicked() {
        showSearchBar(show: true)
    }

    func searchLocationUsingGoogleAPI(_ locationValue: CLLocation, _ searchText: String) {
        GoogleMapsSDKManager.searchPlacesUsingGoogleAPIWithCoordinate(location: locationValue,
                                                                      radius: RhConstants.gmsPlaceSearchRadius,
                                                                      searchText: searchText,
                                                                      completionHandler: { (places, error) in
            if error == nil {
                if places != nil {
                    self.searchResults = places!
                    self.changeLocationTableView.reloadData()
                } else {
                    self.showAlertViewController(message: "Request failed !")
                }
            } else if let error = error {
                self.showAlertViewController(message: error)
            } else {
                self.showAlertViewController(message: "Request failed !")
            }
        })
    }
}

extension SearchLocationViewController: UISearchBarDelegate, UISearchControllerDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let locationValue = locManager.getCurrentLocation() {
            searchLocationUsingGoogleAPI(locationValue, searchBar.text!)
        } else {
            searchLocationUsingGoogleAPI(CLLocation.init(latitude: 0.0, longitude: 0.0), searchBar.text!)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        showSearchBar(show: false)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        for ob: UIView in ((searchBar.subviews[0] )).subviews {
            if let z = ob as? UIButton {
                let btn: UIButton = z
                btn.setTitleColor(UIColor(red:0.00, green:0.67, blue:0.39, alpha:1.0), for: .normal)
            }
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            if let locationValue = locManager.getCurrentLocation() {
                searchLocationUsingGoogleAPI(locationValue, searchText)
            } else {
                searchLocationUsingGoogleAPI(CLLocation.init(latitude: 0.0, longitude: 0.0), searchBar.text!)
            }
        }
    }
}

extension SearchLocationViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: locationTableCellIdentifier)
                                                        as? RhLocationTableViewCell else {
            return UITableViewCell()
        }
        cell.locationLabel.text = searchResults[indexPath.row].name
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if locationSelectedHandler != nil {
            locationSelectedHandler!(CLLocation.init(latitude: searchResults[indexPath.row].latitude!,
                                                     longitude: searchResults[indexPath.row].longitude!),
                                                     searchResults[indexPath.row].name!)
        }
        self.navigationController?.navigationBar.isHidden = false
        _ = navigationController?.popViewController(animated: true)
    }
}
