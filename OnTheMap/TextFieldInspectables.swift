//
//  TextFieldInspectables.swift
//  OnTheMap
//
//  Created by Moath_Othman on 6/6/15.
//  Copyright (c) 2015 Moba. All rights reserved.
//

import Foundation
import UIKit

extension OTMTextField {

  @IBInspectable  var leftInset: CGFloat {
        get {
            return CGFloat(self.leftView!.bounds.size.width);
        }
        set {
            let view = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(newValue), height: CGFloat(0)))
            self.leftViewMode = .Always;
            self.leftView = view;
        }
    }

}
//CGRectMake(0, 0, leftInset, self.frame.size.height)
