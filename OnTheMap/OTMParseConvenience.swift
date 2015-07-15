//
//  OTMParseConvenience.swift
//  OnTheMap
//
//  Created by Moath_Othman on 6/17/15.
//  Copyright (c) 2015 Moba. All rights reserved.
//
import Foundation
//

extension OTMParseClient {

    func queryStudentLocation(uniqueId: String, completion: CommonAPICompletionHandler) {
        //get
        var specialid = "%7B%22uniqueKey%22%3A%22\(uniqueId)%22%7D"
        var parameters = ["where":specialid]

    taskForGETMethod(Methods.StudentLocation, parameters: parameters, completionHandler: { (response, error) -> Void in
        print("\n")
        completion(response: response, error: error)
    }, noescapedParameter: true)

    }
    func updateStudentLocation(objectId: String,uniqueKey: String, firstname: String, lastname: String, mapString: String, mediaUrl: String, latitude: Double, longitude: Double, completionhandler: CommonAPICompletionHandler) {

        let jsonBody = [
            JSONBodyKeys.firstName: firstname,
            JSONBodyKeys.lastName: lastname,
            JSONBodyKeys.uniqueKey: uniqueKey,
            JSONBodyKeys.mapString: mapString,
            JSONBodyKeys.mediaURL: mediaUrl,
            JSONBodyKeys.latitude: latitude,
            JSONBodyKeys.longitude: longitude
        ]

        taskForMethod("PUT", method: Methods.StudentLocation + "/" + objectId, parameters: [String:AnyObject](), jsonBody: jsonBody as! [String : AnyObject]) { (response, error) -> Void in
            if error != nil {
                println("post location errror \(error)")
                completionhandler(response: nil,error: error)
            } else {
                completionhandler(response: response,error: nil)
            }
        }
        
    }

    func getStuduntLocations(limit: Int, comletionhandler:StudentsCompletionHandler) {
        var parameters = ["limit": limit]
        taskForGETMethod(Methods.StudentLocation, parameters: parameters) { (result, errorx) -> Void in
            if let err = errorx {
                comletionhandler(response: nil, error: err)
            }else {
                if let results = result!.valueForKey(OTMParseClient.JSONResponseKeys.results) as? [[String : AnyObject]] {
                    var movies = OTMStudent.studentsFromResults(results)
                    comletionhandler(response: movies, error: nil)
                }else {
                    comletionhandler(response: nil, error: NSError(domain: "students", code: 99, userInfo: nil))
                }
            }
        }
    }

    func postStudentLocation(uniqueKey: String, firstname: String, lastname: String, mapString: String, mediaUrl: String, latitude: Double, longitude: Double, completionhandler: CommonAPICompletionHandler) {

        let jsonbody = [
            JSONBodyKeys.firstName: firstname,
            JSONBodyKeys.lastName: lastname,
            JSONBodyKeys.uniqueKey: uniqueKey,
            JSONBodyKeys.mapString: mapString,
            JSONBodyKeys.mediaURL: mediaUrl,
            JSONBodyKeys.latitude: latitude,
            JSONBodyKeys.longitude: longitude
        ]

        taskForPOSTMethod(Methods.StudentLocation, parameters: [String:AnyObject](), jsonBody: jsonbody as! [String : AnyObject]) { (result, error) -> Void in
            if error != nil {
                println("post location errror \(error)")
                completionhandler(response: nil,error: error)
            } else {
                completionhandler(response: result,error: nil)

            }
        }

    }

    
}
