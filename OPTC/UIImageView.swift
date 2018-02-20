//
//  UIImageView.swift
//  OPTC
//
//  Created by Prashant on 2/19/18.
//  Copyright © 2018 Prashant. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    
    func loadImage(_ url: URL) {
        self.sd_setImageWithPreviousCachedImage(with: url, placeholderImage: nil, options: .retryFailed, progress: nil) { (image, error,_, _) in
            if image != nil {
                print("Image downloaded successfully")
            } else {
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
