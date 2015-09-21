//
//  OTMUdacityConvenience.swift
//  OnTheMap
//
//  Created by Moath_Othman on 6/13/15.
//  Copyright (c) 2015 Moba. All rights reserved.
//

import Foundation


extension OTMUdacityClient {

    func loginWithFacebook(accessToken: String!,completionHandler:(success: Bool,sessionID: String?, errorString: NSError?)-> Void) {
        let jsonbody = [
            JSONBodyKeys.facebook_mobile: [
                JSONBodyKeys.access_token : accessToken
            ]
        ]
        createASession(jsonbody, completionHandler: completionHandler)
    }
    func loginWithCredntials(username: String, password: String, completionHandler:(success: Bool,sessionID: String?, errorString: NSError?)-> Void) {
        let credientials : [String:AnyObject] = [
            OTMUdacityClient.JSONBodyKeys.UserName: username,
            OTMUdacityClient.JSONBodyKeys.Password: password,
        ]
        let jsonbody: [String:AnyObject] = [
            "udacity": credientials,
        ]

        createASession(jsonbody, completionHandler: completionHandler)
    }
    func createASession(jsonbody:[String: AnyObject]!, completionHandler:(success: Bool,sessionID: String?, errorString: NSError?)-> Void) {
        let parameters = [String: AnyObject]()

        taskForPOSTMethod(OTMUdacityClient.Methods.session, parameters: parameters, jsonBody: jsonbody) { (JSONResult, error) -> Void in
            if let error = error {
                completionHandler(success: false, sessionID: nil, errorString: error)
            } else {
                if let account = JSONResult!.valueForKey(OTMUdacityClient.JSONResponseKeys.account) as? [String:AnyObject] {
                    if let userid = account[OTMUdacityClient.JSONResponseKeys.key] as? String {
                        OTMUdacityClient.sharedInstance().userID = userid
                    }
                }
                if let session = JSONResult!.valueForKey(OTMUdacityClient.JSONResponseKeys.session) as? [String:AnyObject] {
                    if let id = session[OTMUdacityClient.JSONResponseKeys.id] as? String {
                        
                    completionHandler(success: true, sessionID: id, errorString: nil)
                        OTMUdacityClient.sharedInstance().isLoggedIn = true
                    }
                } else {
                    if let _err = JSONResult?.valueForKey(OTMUdacityClient.JSONResponseKeys.error) as? String {
                    completionHandler(success: false, sessionID: nil, errorString:  NSError(domain: "login", code: 0, userInfo: [NSLocalizedDescriptionKey: _err]))
                    }
                }
            }
        }
        }

    func logout(completionHandler:(success: Bool, errorString: NSError?)-> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as [NSHTTPCookie]! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-Token")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if error != nil { // Handle error…
                    return
                }
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
                print(NSString(data: newData, encoding: NSUTF8StringEncoding))
                OTMUdacityClient.parseJSONWithCompletionHandler(newData, completionHandler: { (JSONResult, error) -> Void in
                    if let error = error {
                        completionHandler(success: false, errorString: error)
                    } else {

                        if let session = JSONResult!.valueForKey(OTMUdacityClient.JSONResponseKeys.session) as? [String:AnyObject] {
                            if let _ = session[OTMUdacityClient.JSONResponseKeys.id] as? String {
                                completionHandler(success: true, errorString: nil)
                                OTMUdacityClient.sharedInstance().isLoggedIn = false
                            }
                        } else {
                            completionHandler(success: false,errorString:  NSError(domain: "postToWatchlist parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToWatchlist"]))
                        }
                    }
            })

            })

        }
        task.resume()

    }

    func getDataForUser(userID: String,completionHandler:CommonAPICompletionHandler ){
        taskForGETMethod(OTMUdacityClient.Methods.users + "/" + userID, parameters: [String: AnyObject]()) { (result, error) -> Void in
            if let _ = error {
                completionHandler(response: nil, error: error)
            } else {
                completionHandler(response: result, error: nil)

            }
        }

    }




}
