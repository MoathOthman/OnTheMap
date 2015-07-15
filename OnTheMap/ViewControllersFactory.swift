//
//  ViewControllersFactory.swift
//  OnTheMap
//
//  Created by Moath_Othman on 6/14/15.
//  Copyright (c) 2015 Moba. All rights reserved.
//
import UIKit

/*These are storyBoards ids and not nec. the classes of the viewcontrollers
  since classes names are more likely to change
*/
struct StoryBoardIdentifiers {
    static let login = "LoginViewController"
    static let locations = "OTMLocationsViewController"
    static let map = "OTMMapViewController"
    static let signup = "OTMSignupViewController"
    static let locationsTable = "OTMLocationsListViewController"
    static let postlocation = "OTMLocationPostViewController"
    static let submitInfo = "OTMSubmitInfoViewController"
    static let locationsnavigation = "LocationNavigation"
}

enum ViewControllerType {
    case Locations, Login, Map, LocationsList, Signup , postLocation, submitInfo, locationsNavigation
}


class ViewControllersFactory {
    class func make(type : ViewControllerType) -> AnyObject {
        var mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        switch type {
        case .Locations:
            return mainStoryBoard.instantiateViewControllerWithIdentifier(StoryBoardIdentifiers.locations)
        case .Login:
            return mainStoryBoard.instantiateViewControllerWithIdentifier(StoryBoardIdentifiers.login)
        case .Map:
            return mainStoryBoard.instantiateViewControllerWithIdentifier(StoryBoardIdentifiers.map)
        case .postLocation:
            return mainStoryBoard.instantiateViewControllerWithIdentifier(StoryBoardIdentifiers.postlocation)
        case .submitInfo:
            return mainStoryBoard.instantiateViewControllerWithIdentifier(StoryBoardIdentifiers.submitInfo)
        case .locationsNavigation:
            return mainStoryBoard.instantiateViewControllerWithIdentifier(StoryBoardIdentifiers.locationsnavigation)
        default:
            NSException.raise("No Scene found", format: "please update storyboard ids", arguments: CVaListPointer(_fromUnsafeMutablePointer: nil))
            return mainStoryBoard.instantiateViewControllerWithIdentifier("")
        }
    }
}
