//
//  UIViewController+Extension.swift
//  OPTC
//
//  Created by Mac on 3/26/18.
//  Copyright © 2018 Prashant. All rights reserved.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    func showHud(_ title: String, details: String = "") {
        self.hideHUD()
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = title
        hud.detailsLabel.text = details
        hud.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = false
    }
    
    func hideHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
        self.view.isUserInteractionEnabled = true
    }
}
