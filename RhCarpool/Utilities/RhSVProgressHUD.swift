//
//  RhSVProgressHUD.swift
//  RhCarpool
//
//  Created by Ravi on 24/09/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import SVProgressHUD

open class RhSVProgressHUD: NSObject {
    static func showIndicator(status: String) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.flat)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.show(withStatus: status)
    }
    static func hideIndicator() {
        UIApplication.shared.endIgnoringInteractionEvents()
        SVProgressHUD.dismiss()
    }
}
