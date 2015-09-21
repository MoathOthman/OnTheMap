//
//  OTMParseClient.swift
//  OnTheMap
//
//  Created by Moath_Othman on 6/17/15.
//  Copyright (c) 2015 Moba. All rights reserved.
//

import UIKit

class OTMParseClient: NSObject {


    /* Shared session */
    var session: NSURLSession

    /* Configuration object */

    /* Authentication state */
    var sessionID : String? = nil
    var userID : String? = nil
    var isLoggedIn: Bool {
        get{
            return NSUserDefaults.standardUserDefaults().boolForKey("isLoggedIn");
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "isLoggedIn")
        }
    }
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }

    // MARK: - GET
    func taskForGETMethod(method: String, parameters: [String : AnyObject], completionHandler: CommonAPICompletionHandler) -> NSURLSessionDataTask {
        return taskForGETMethod(method, parameters: parameters, completionHandler: completionHandler, noescapedParameter: false)
    }
    func taskForGETMethod(method: String, parameters: [String : AnyObject], completionHandler: CommonAPICompletionHandler, noescapedParameter: Bool ) -> NSURLSessionDataTask {

        /* 1. Set the parameters */
        let mutableParameters = parameters

        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.BaseURLSecure + method + OTMParseClient.escapedParameters(mutableParameters,addingPercentage: noescapedParameter)
        print("urlString \(urlString)", terminator: "")
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.addValue(ParameterKeys.parseApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParameterKeys.parseRestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
          dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let error = downloadError {
                _ = OTMUdacityClient.errorForData(data, response: response, error: error)
                completionHandler(response: nil, error: downloadError)
            } else {
                  OTMParseClient.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
            }
          })
           
        }

        /* 7. Start the request */
        task.resume()

        return task
    }


    // MARK: - POST
    func taskForPOSTMethod(method: String, parameters: [String : AnyObject], jsonBody: [String:AnyObject], completionHandler: CommonAPICompletionHandler)  {
        taskForMethod("POST",method: method, parameters: parameters, jsonBody: jsonBody, completionHandler: completionHandler)
    }
    func taskForMethod(httpMethod: String,method: String, parameters: [String : AnyObject], jsonBody: [String:AnyObject], completionHandler: CommonAPICompletionHandler) -> NSURLSessionDataTask {

        /* 1. Set the parameters */
        var mutableParameters = parameters
        mutableParameters[ParameterKeys.ApiKey] = Constants.ApiKey

        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.BaseURLSecure + method + OTMParseClient.escapedParameters(mutableParameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
//        var jsonifyError: NSError? = nil
        request.HTTPMethod = httpMethod
        request.addValue(ParameterKeys.parseApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParameterKeys.parseRestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonBody, options: [])
        } catch _ as NSError {
//            jsonifyError = error
            request.HTTPBody = nil
        }

        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let error = downloadError {
                    _ = OTMUdacityClient.errorForData(data, response: response, error: error)
                    completionHandler(response: nil, error: downloadError)
                } else {
                    OTMParseClient.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
                }
            })

        }

        task.resume()

        return task
    }

    // MARK: - Helpers

    /* Helper: Substitute the key for the value that is contained within the method name */
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }

    /* Helper: Given a response with error, see if a status_message is returned, otherwise return the previous error */
    class func errorForData(data: NSData?, response: NSURLResponse?, error: NSError) -> NSError {

        if let _ = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as? [String : AnyObject] {

//            if let errorMessage = parsedResult[OTMParseClient.JSONResponseKeys.StatusMessage] as? String {
//
//                let userInfo = [NSLocalizedDescriptionKey : errorMessage]
//
//                return NSError(domain: "TMDB Error", code: 1, userInfo: userInfo)
//            }
        }

        return error
    }

    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {

        var parsingError: NSError? = nil

        let parsedResult: AnyObject?
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        } catch let error as NSError {
            parsingError = error
            parsedResult = nil
        }

        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }


    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {

        return escapedParameters(parameters, addingPercentage: false)
    }
    class func escapedParameters(parameters: [String : AnyObject],addingPercentage:Bool) -> String {

        var urlVars = [String]()

        for (key, value) in parameters {

            /* Make sure that it is a string value */
            let stringValue = "\(value)"

            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())

            /* Append it */
            urlVars += [key + "=" + "\(addingPercentage ? stringValue:escapedValue!)"]

        }

        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }


    
    // MARK: - Shared Instance

    class func sharedInstance() -> OTMParseClient {

        struct Singleton {
            static var sharedInstance = OTMParseClient()
        }

        return Singleton.sharedInstance
    }
}


extension OTMParseClient {

    // MARK: - Constants
    struct Constants {
        // MARK: API Key
        static let ApiKey : String         = "fbde12deddfe0e1184209ed987177663"
        // MARK: URLs
        static let BaseURLSecure : String  = "https://api.parse.com/1/classes/"
        static let signUpWebURL: NSURL?    = NSURL(string: "https://www.google.com/url?q=https%3A%2F%2Fwww.udacity.com%2Faccount%2Fauth%23!%2Fsignin&sa=D&sntz=1&usg=AFQjCNERmggdSkRb9MFkqAW_5FgChiCxAQ")
    }

    // MARK: - Methods
    struct Methods {
        static let StudentLocation = "StudentLocation"
        
    }

    // MARK: - URL Keys
    struct URLKeys {


    }

    // MARK: - Parameter Keys
    struct ParameterKeys {
        static let ApiKey             = "api_key"
        static let parseApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let parseRestAPIKey    = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"

    }

    // MARK: - JSON Body Keys
    struct JSONBodyKeys {
        /*Post Student Loication*/
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName  = "lastName"
        static let mapString = "mapString"
        static let mediaURL  = "mediaURL"
        static let latitude  = "latitude"
        static let longitude = "longitude"

    }

    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        static let        createdAt = "createdAt"
        static let        firstName = "firstName"
        static let        lastName  = "lastName"
        static let        latitude  = "latitude"
        static let        longitude = "longitude"
        static let        mapString = "mapString"
        static let        mediaURL  = "mediaURL"
        static let        objectId  = "objectId"
        static let        uniqueKey = "uniqueKey"
        static let        updatedAt = "updatedAt"
        static let        results   = "results"
        
    }
}
