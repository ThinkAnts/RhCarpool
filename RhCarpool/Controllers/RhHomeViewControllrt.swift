//
//  RhHomeViewControllrt.swift
//  RhCarpool
//
//  Created by Ravi on 30/04/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import UIKit

class RhHomeViewController: RhBaseViewController {
    @IBOutlet weak var carPoolTableView: UITableView!
    @IBOutlet weak var carPoolSegment: UISegmentedControl!
    fileprivate var carPoolList = [CarPoolDetails]()
    fileprivate var myCarPoolList = [CarPoolDetails]()
    fileprivate let buttonBar = UIView()
    fileprivate var selectedSegmentIndex = 0
    fileprivate var otherCarPoolList = [CarPoolDetails]()
    override func viewDidLoad() {
        carPoolTableView.register(UINib(nibName: "RhCarpoolCell", bundle: nil), forCellReuseIdentifier: "carpool")
        setSegmentView()
        addBottomBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.myCarPoolList.removeAll()
        self.otherCarPoolList.removeAll()
    }

    override func viewWillAppear(_ animated: Bool) {
        setup(title: "RH CarPool")
        loadInitialView()
        carPoolTableView.isHidden = true
        carPoolSegment.isHidden = true
        self.buttonBar.isHidden = true
        fetchCarPoolDetails(timeStamp: getTodaysDate())
    }

    func loadInitialView() {
        self.navigationController?.navigationItem.hidesBackButton = true
        let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings").withRenderingMode(.alwaysOriginal),
                                             style:  UIBarButtonItemStyle.plain,
                                             target: self, action: #selector(RhHomeViewController.settingsAction))
        self.navigationItem.leftBarButtonItem = settingsButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        let addButton = UIBarButtonItem(image: #imageLiteral(resourceName: "add").withRenderingMode(.alwaysOriginal),
                                        style: UIBarButtonItemStyle.plain,
                                        target: self, action: #selector(RhHomeViewController.addAction))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        let profileUrl = UserDefaults.getProfileUrl()
        if profileUrl == "" {
            UserDefaults.storeProfileUrl(url: UserDefaults.getUserData()?.photoUrl ?? "")
        }
    }

    func fetchCarPoolDetails(timeStamp: String) {
        RhSVProgressHUD.showIndicator(status: "Fetching Data")
        FireBaseDataBase.sharedInstance.getCarPoolDetails(timeStamp: timeStamp,
                                                             completion: { [weak self] response, carPoolData in
            if response == "Success", carPoolData.count > 0 {
                RhSVProgressHUD.hideIndicator()
                self?.carPoolList = carPoolData
                self?.differentiateCarpools()
            } else {
                // Error Block
                RhSVProgressHUD.hideIndicator()
                self?.showAlertViewController(message: response)
            }
        })
    }

    func differentiateCarpools() {
        if self.carPoolList.count > 0 {
            for (index, carPoolDetail) in self.carPoolList.enumerated() {
                print("Found \(carPoolDetail) at position \(index)")
                if carPoolDetail.uid == UserDefaults.getUid() {
                    self.myCarPoolList.append(carPoolDetail)
                } else {
                    self.otherCarPoolList.append(carPoolDetail)
                }
            }
            self.carPoolTableView.isHidden = false
            self.carPoolSegment.isHidden = false
            self.buttonBar.isHidden = false
            self.carPoolTableView.reloadData()
        }
    }
    @objc func addAction() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "newcarpool")
                                                            as? RhCreateNewCarPoolController else {
            return
        }
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }

    @objc func settingsAction() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "settings")
                                                                 as? RhSettingsViewController else {
              return
        }
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }

    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.3) {
            let width = self.carPoolSegment.frame.width
            let noOfSegments = self.carPoolSegment.numberOfSegments
            self.selectedSegmentIndex = self.carPoolSegment.selectedSegmentIndex
            self.buttonBar.frame.origin.x = (width/CGFloat(noOfSegments)) * CGFloat(self.selectedSegmentIndex)
            self.carPoolTableView.reloadData()
        }
    }

    func addBottomBar() {
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = UIColor.rhGreen
        view.addSubview(buttonBar)
        buttonBar.topAnchor.constraint(equalTo: carPoolSegment.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        buttonBar.leftAnchor.constraint(equalTo: carPoolSegment.leftAnchor).isActive = true
        buttonBar.widthAnchor.constraint(equalTo: carPoolSegment.widthAnchor,
                                         multiplier: 1 / CGFloat(carPoolSegment.numberOfSegments)).isActive = true
    }

    func setSegmentView() {
        carPoolSegment.backgroundColor = UIColor.white
        carPoolSegment.tintColor = .clear
        carPoolSegment.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black,
                                               NSAttributedStringKey.font:
                                                UIFont(name: RhConstants.SFReg, size: 14) as Any],
                                              for: .normal)
        carPoolSegment.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black,
                                               NSAttributedStringKey.font:
                                                UIFont(name: RhConstants.SFBold, size: 14) as Any],
                                              for: .selected)
    }
}
extension RhHomeViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedSegmentIndex == 0 {
          return self.myCarPoolList.count
        }
        return self.otherCarPoolList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let carPoolCell = tableView.dequeueReusableCell(withIdentifier: "carpool") as? RhCarPoolCell else {
            return UITableViewCell()
        }
        if selectedSegmentIndex == 0 {
           let carPoolDetail = self.myCarPoolList[indexPath.row]
            carPoolCell.setupData(carPoolDetail: carPoolDetail)
            return carPoolCell
        } else if selectedSegmentIndex == 1 {
          let carPoolDetail = self.otherCarPoolList[indexPath.row]
          carPoolCell.setupData(carPoolDetail: carPoolDetail)
          return carPoolCell
        }
        return carPoolCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
