//
//  RhProfileViewController.swift
//  RhCarpool
//
//  Created by Ravi on 01/05/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class RhProfileViewController: RhBaseViewController, UINavigationControllerDelegate {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var zoneTextField: UITextField!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    weak var delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?
    var imagePicker: UIImagePickerController?
    var values = ["East", "West", "North", "South"]
    let cellReuseIdentifier = "cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = delegate
    }

    override func viewWillAppear(_ animated: Bool) {
        setup(title:"Profile")
        profileView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileView.layer.masksToBounds = true
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back").withRenderingMode(.alwaysOriginal), style: UIBarButtonItemStyle.plain,
                                         target: self, action: #selector(RhWebViewController.goBack))
        self.navigationItem.leftBarButtonItem = backButton
    }

    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func editProfilePicAction(_ sender: UIButton) {
        showAddFilePopUpView()
    }

    func showAddFilePopUpView() {
        let popUpView = RhChooseImagePopUp.loadFromNib()
        popUpView?.center = CGPoint(x: view.bounds.midX,
                                  y: view.bounds.midY)
        popUpView?.layer.shadowColor = UIColor.darkGray.cgColor
        popUpView?.layer.shadowRadius = 5.0
        popUpView?.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        popUpView?.layer.shadowOpacity = 1.0
        popUpView?.clipsToBounds = false
        popUpView?.tag = 0001
        popUpView?.layer.masksToBounds = false
        self.view.addSubview(popUpView!)
    }

    func openCamera() {
        imagePicker(sourceType: .camera)
    }

    func openGallary() {
        imagePicker(sourceType: .photoLibrary)
    }

    func imagePicker(sourceType: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            imagePicker?.sourceType = sourceType
            imagePicker?.allowsEditing = false
            self.present(imagePicker!, animated: true, completion: nil)
        }
    }
}

extension RhProfileViewController: UIImagePickerControllerDelegate {
    private func imagePickerController(_ picker: UIImagePickerController,
                                       didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        profileImageView.image = image
        dismiss(animated:true, completion: nil)
    }
}
