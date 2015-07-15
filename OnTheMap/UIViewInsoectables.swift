//
//  UIViewInsoectables.swift
//  OnTheMap
//
//  Created by Moath_Othman on 7/2/15.
//  Copyright (c) 2015 Moba. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable  var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius;
        }
        set {
            self.layer.cornerRadius = newValue
            self.clipsToBounds = true
        }
    }
}
