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
import FirebaseStorage
import SDWebImage

class RhProfileViewController: RhBaseViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var zoneTextField: UITextField!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var runningProgramField: UITextField!

    var imagePicker = UIImagePickerController()
    var uidString: String?
    var photoUrlString: String?
    var isProfileImageChanged = false
    let storage = Storage.storage()
    var profileImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(RhBaseViewController.handleSingleTap))
        view.addGestureRecognizer(tapRecognizer)
        NotificationCenter.default.addObserver(self, selector: #selector(RhProfileViewController.keyboardWillShow),
                                                     name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RhProfileViewController.keyboardWillHide),
                                                     name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        setup(title:"My Profile")
        if isProfileImageChanged == false {
            loadProfileData()
        }
        profileView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileView.layer.masksToBounds = true
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back").withRenderingMode(.alwaysOriginal), style: UIBarButtonItemStyle.plain,
                                         target: self, action: #selector(RhWebViewController.goBack))
        self.navigationItem.leftBarButtonItem = backButton
    }

    deinit {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    func loadProfileData() {
        guard let user = UserDefaults.getUserData() else {
            return
        }
        fullName.text = user.fullName
        emailAddress.text = user.email
        mobileNumber.text = user.mobileNumber
        zoneTextField.text = user.direction
        uidString = user.uidString
        runningProgramField.text = user.runningProgram
        photoUrlString = user.photoUrl
        if let profileImage = URL(string: photoUrlString ?? "") {
            profileImageView.sd_setImage(with: profileImage, placeholderImage: #imageLiteral(resourceName: "face"))
        }
    }

    @IBAction func editProfilePicAction(_ sender: UIButton) {
        showAddFilePopUpView()
    }

    func fixImageOrientation(_ image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        image.draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? image
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
        popUpView?.tag = 0010
        popUpView?.layer.masksToBounds = false
        self.view.addSubview(popUpView!)
        NotificationCenter.default.addObserver(self, selector: #selector(RhProfileViewController.openCamera),
                                               name: NSNotification.Name(rawValue: "choosePhoto"), object: nil)
    }

    @objc func openCamera(notification: NSNotification) {
        let selectedType = notification.object as? String
        if selectedType == "openCamera" {
            imagePicker(sourceType: .camera)
        } else if selectedType == "openGallery" {
            imagePicker(sourceType: .photoLibrary)
        }

        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "choosePhoto"), object: nil)
        closeView()
    }

    func closeView() {
        for view in self.view.subviews where view.tag == 0010 {
            view.removeFromSuperview()
        }
    }

    func imagePicker(sourceType: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = false
            var topVC = UIApplication.shared.keyWindow?.rootViewController
            while (topVC?.presentedViewController) != nil {
                topVC = topVC?.presentedViewController
            }
            topVC?.present(imagePicker, animated: true, completion: nil)
        }
    }

    @IBAction func saveAction(_ sender: Any) {
        RhSVProgressHUD.showIndicator(status: "Saving Data")
        if isProfileImageChanged == true {
            let background = DispatchQueue.global()
            background.async {
                self.saveProfileImageInBackground()
            }
        }
        self.updateUserData()
    }

    func saveProfileImageInBackground() {
        uploadMedia {[weak self] (urlString) in
            if urlString != "" {
                self?.photoUrlString = urlString
                self?.isProfileImageChanged = false
            }
            FireBaseDataBase.sharedInstance.updateCarpoolData(profileUrl: (self?.photoUrlString)!,
                                                              uid: self?.uidString ?? "",
                                                              timeStamp: self?.getTodaysDate() ?? "")
        }
    }

    // MARK: - Upload datato firebase
    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
        let ref = Storage.storage().reference(withPath: "media/userMainPhoto").child(uidString! + ".png")
        let uploadingImage = fixImageOrientation(profileImageView.image!)
        if let uploadData = UIImagePNGRepresentation(uploadingImage) {
            ref.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    completion((metadata?.downloadURL()?.absoluteString)!)
                    // your uploaded photo url.
                }
            }
        }
    }

    func updateUserData() {
        let userDetails: [String: String] = [RhConstants.emailAddress: emailAddress.text ?? "",
                                             RhConstants.fullName: fullName.text ?? "",
                                             RhConstants.mobileNumber: mobileNumber.text ?? "",
                                             RhConstants.direction: zoneTextField.text ?? "",
                                             RhConstants.runningProgram: runningProgramField.text ?? "",
                                             RhConstants.photoUrl: photoUrlString ?? ""]

        FireBaseDataBase.sharedInstance.updateUserData(user: userDetails, uidValue: uidString ?? "")
        RhSVProgressHUD.hideIndicator()
        RhSVProgressHUD.showSuccessMessage(status: "Saved", imageString: "tick")
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}

extension RhProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImage = image
            profileImageView.image = profileImage
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage = image
            profileImageView.image = profileImage
        } else {
            print("Something went wrong")
        }
        profileImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        profileImageView.contentMode = .scaleAspectFill
        isProfileImageChanged = true
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isProfileImageChanged = false
        dismiss(animated: true, completion: nil)
    }
}
extension RhProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
