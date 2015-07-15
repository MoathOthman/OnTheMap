//
//  OTMContentsViewController.swift
//  OnTheMap
//
//  Created by Moath_Othman on 6/14/15.
//  Copyright (c) 2015 Moba. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class OTMLocationsViewController: UIViewController {
    var listStudentsViewController: OTMLocationsListViewController?
    var locationsMapViewController: OTMMapViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareChildViewControllers()
        parseUserPublocData()
        getStudentLocations()
        configureNavigationBar()
        queryTheCurrentUser()
    }
    func prepareChildViewControllers() {
        var tabbarController = self.childViewControllers[0] as! UITabBarController
        if var mapViewController: OTMMapViewController = tabbarController.viewControllers?[0] as? OTMMapViewController  {
            self.locationsMapViewController = mapViewController
        }
        if let locationsListNav = tabbarController.viewControllers?[1] as?  UINavigationController
        {
            if var listViewController = locationsListNav.viewControllers?[0] as? OTMLocationsListViewController {
                self.listStudentsViewController = listViewController
            }
        }
    }
    func queryTheCurrentUser() {
        // This will give us data if the user has a previous locations 
        OTMParseClient.sharedInstance().queryStudentLocation(OTMUdacityClient.sharedInstance().userID!, completion: { (response, error) -> Void in
            OTMStudent.fillUserFromJson(response)
            if OTMStudent.thisUser().latitude != nil {/*make sure he has info */
            self.locationsMapViewController?.thisUser = OTMStudent.thisUser()
            }
            print("quesrystudenmtlocaiton \(OTMStudent.thisUser().latitude)\n")
        })
    }
    func parseUserPublocData() {
        OTMUdacityClient.sharedInstance().getDataForUser(OTMUdacityClient.sharedInstance().userID!, completionHandler: { (results, err) -> Void in
            OTMStudent.fillUserFromJson(results)
        })
    }
    func getStudentLocations() {
        MOHUD.show()
        OTMParseClient.sharedInstance().getStuduntLocations(100, comletionhandler: { (response, error) -> Void in
//                    print("users response \(response)")
            if let err: NSError = error  {
                MOHUD.showWithError(err.localizedDescription)
            }else {
            self.locationsMapViewController?.students = response
            self.listStudentsViewController?.students = response
            MOHUD.dismiss()
            }
        })
    }
    @IBAction func postLocation(sender: AnyObject) {
        if OTMStudent.checkIfUserHasAlreadyALocation() {
            showOverwriteAlert()
            isTheUserOverwritingHisOldLocation = true
        }else {
            bringThePostLocationViewcontroller()
        }
    }
    func bringThePostLocationViewcontroller() {
        self.presentViewController(ViewControllersFactory.make(.postLocation) as! UIViewController, animated: true) { () -> Void in
        }
    }

     @IBAction func logout(sender: AnyObject) {

        if checkIfUSerLoggedInUsingFacebook() {
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
            })
            return
        }
        MOHUD.show("Logging out")

        OTMUdacityClient.sharedInstance().logout { (success, errorString) -> Void in
            if success {
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                })
                MOHUD.dismiss()
            } else {
                print("not able to logout")
                MOHUD.showWithError("Not able to logout, check your connection", delay: 2)
            }

        }
    }

    @IBAction func refreshdata(sender: AnyObject) {
        getStudentLocations()
    }
    //MARK UI
    func configureNavigationBar() {
        self.title = "On The Map"
        var navigationbarItem = UIBarButtonItem(image: UIImage(named: "pin"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("postLocation:"))
        var _arrayOfbutton: [AnyObject]? = self.navigationItem.rightBarButtonItems
       _arrayOfbutton?.append(navigationbarItem)
        self.navigationItem.rightBarButtonItems = _arrayOfbutton
    }
    //MARK: Helper

    func showOverwriteAlert() {
        var thisuser = OTMStudent.thisUser()
        var fullname = thisuser.firstName! + " " + thisuser.lastName!
        var alert = UIAlertController(title: "", message: "User \"\(fullname)\" Has Already Posted a Student Location. Would You Like to Overwrite Their Location", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
            self.bringThePostLocationViewcontroller()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func checkIfUSerLoggedInUsingFacebook()-> Bool {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            //user has already a token
            var facebookmanager = FBSDKLoginManager()
              facebookmanager.logOut()
            return true
        }

        return false
    }

}
