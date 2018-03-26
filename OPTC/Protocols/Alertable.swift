//
//  Alertable.swift
//  CareCareer
//
//  Created by Narendra Kathayat on 11/24/17.
//  Copyright © 2017 Narendra Kathayat. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

protocol Alertable {}
extension Alertable where Self: UIViewController {
    
//    func alert(with buttons: [AlertButtonType], and message: String, type: AlertType, action:((_ buttonType: AlertButtonType)-> Swift.Void)?) {
//        PopOverAlertPresenter.shared.showAlert(with: buttons, and: message, ofType: type, onCompletion: action)
//    }
    
    func progressIndicator(with message: String) {
        PopOverAlertPresenter.shared.showIndicator(with: message)
    }
    
    func hideIndicator() {
        PopOverAlertPresenter.shared.hideIndicator()
    }
}

class PopOverAlertPresenter {
    
    static let shared = PopOverAlertPresenter()
    private init() {}
    //fileprivate var alertPopup: CareCareerAlert?
    fileprivate var progressHUD: MBProgressHUD?
    let newWindow = UIWindow()
    let restorationIdentifier = "PopOverAlertBox"
    
//    func showAlert(with buttons: [AlertButtonType], and message: String, ofType type: AlertType, onCompletion:((_ buttonType: AlertButtonType)-> Swift.Void)?) {
//        alertPopup = CareCareerAlert(frame: UIScreen.main.bounds)
//        guard let alertPopup = alertPopup else {return}
//        alertPopup.restorationIdentifier = restorationIdentifier
//        alertPopup.display(with: buttons, and: message, ofType: type) { (buttonType) in
//            self.hide()
//            if let onCompletion = onCompletion {
//                DispatchQueue.main.async {
//                    onCompletion(buttonType)
//                }
//            }
//        }
//        guard let keyWindow = UIApplication.shared.keyWindow else { return }
//        keyWindow.addSubview(alertPopup)
//        alertPopup.subHolder.animateShow()
//    }
    
//    func hide() {
//        guard let keyWindow = UIApplication.shared.keyWindow else { return }
//
//        for item in keyWindow.subviews
//            where item.restorationIdentifier == restorationIdentifier {
//                if item is CareCareerAlert {
//                    if let itemAlertView = item as? CareCareerAlert {
//                        itemAlertView.subHolder.hideAnimate({ (done) in
//                            itemAlertView.removeFromSuperview()
//                        })
//                    }
//                }
//        }
//    }
    
    func showIndicator(with title: String) {
        progressHUD = MBProgressHUD(frame: UIScreen.main.bounds)
        guard let progressHUD = progressHUD else {return}
        progressHUD.restorationIdentifier = restorationIdentifier
        progressHUD.label.text = title
        progressHUD.backgroundView.style = .solidColor
        progressHUD.backgroundView.color = UIColor.black.withAlphaComponent(0.5)
        progressHUD.animationType = .zoomIn
        progressHUD.label.textColor = UIColor.red
        progressHUD.bezelView.backgroundColor = .white
        
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        keyWindow.addSubview(progressHUD)
        progressHUD.show(animated: true)
    }
    
    func hideIndicator() {
        guard let progressHUD = progressHUD else {return}
        progressHUD.hide(animated: true)
        self.progressHUD = nil
    }
}
