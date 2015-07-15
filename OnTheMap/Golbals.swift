//
//  Golbals.swift
//  OnTheMap
//
//  Created by Moath_Othman on 7/2/15.
//  Copyright (c) 2015 Moba. All rights reserved.
//

import Foundation


//MARK: completion handlers
typealias StudentsCompletionHandler = (response: [OTMStudent]?,error : NSError?) -> Void
typealias CommonAPICompletionHandler =  (response: AnyObject?,error : NSError?) -> Void

var isTheUserOverwritingHisOldLocation = false