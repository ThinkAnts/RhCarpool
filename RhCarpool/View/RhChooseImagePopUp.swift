//
//  RhChooseImagePopUp.swift
//  RhCarpool
//
//  Created by Ravi on 23/09/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import UIKit

class RhChooseImagePopUp: UIView {
    @IBOutlet weak var takePic: UIButton!
    @IBOutlet weak var chooseFromGallery: UIButton!
    let profileVC = RhProfileViewController()

    // MARK: - mark Singleton Methods
    class func loadFromNib() -> (RhChooseImagePopUp?) {
        if let nib = Bundle.main.loadNibNamed("RhChooseImagePopUp", owner: self,
                                              options: nil)?.first as? RhChooseImagePopUp {
            return nib
        }
        return nil
    }

    // MARK: - Initialize Method
    override func awakeFromNib() {
        super.awakeFromNib()
        takePic.layer.borderColor = UIColor.rhGreen.cgColor
        chooseFromGallery.layer.borderColor = UIColor.rhGreen.cgColor
    }

    func showInView(view: UIView) {
        self.frame = view.frame
        self.alpha = 0.0
        self.isHidden = false
        let doesContain = view.subviews.contains(self)
        if !doesContain {
            view.addSubview(self)
        }
        self.setNeedsDisplay()
        weak var weakSelf = self
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            weakSelf?.alpha = 1.0
        }, completion: nil)
    }

    func closeView() {
        self.removeFromSuperview()
    }

    @IBAction func cameraAction() {
        profileVC.openCamera()
        self.removeFromSuperview()
    }

    @IBAction func photoGalleryAction() {
        profileVC.openGallary()
        self.removeFromSuperview()
    }
}
