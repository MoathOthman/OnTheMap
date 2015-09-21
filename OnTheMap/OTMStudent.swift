//
//  OTMStudent.swift
//  OnTheMap
//
//  Created by Moath_Othman on 6/17/15.
//  Copyright (c) 2015 Moba. All rights reserved.
//
import AddressBook
import UIKit
import MapKit
class OTMStudent: NSObject, MKAnnotation {
    var createdAt: String?
    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    var uniqueKey: String?
    override init() {

    }
    /* Construct a TMDBMovie from a dictionary */
    init(dictionary: [String : AnyObject]) {
         createdAt = dictionary[OTMParseClient.JSONResponseKeys.createdAt] as? String
         firstName = dictionary[OTMParseClient.JSONResponseKeys.firstName] as? String
         lastName  = dictionary[OTMParseClient.JSONResponseKeys.lastName]  as? String
         mapString = dictionary[OTMParseClient.JSONResponseKeys.mapString] as? String
         mediaURL  = dictionary[OTMParseClient.JSONResponseKeys.mediaURL]  as? String
         latitude  = dictionary[OTMParseClient.JSONResponseKeys.latitude]  as? Double
         longitude = dictionary[OTMParseClient.JSONResponseKeys.longitude] as? Double
         objectId  = dictionary[OTMParseClient.JSONResponseKeys.objectId]  as? String
         uniqueKey = dictionary[OTMParseClient.JSONResponseKeys.uniqueKey] as? String
    }


    /* Helper: Given an array of dictionaries, convert them to an array of otmstuden objects */
    static func studentsFromResults(results: [[String : AnyObject]]) -> [OTMStudent] {
        var students = [OTMStudent]()

        for result in results {

            students.append(OTMStudent(dictionary: result))
        }

        return students
    }

    var subtitle: String? {
        if let murl = mediaURL {
            return murl
        }
        return  ""
    }
    var title: String? {
        if let _ = firstName {
        return firstName!
        }
        return ""
    }
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
    }

    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary as [String: AnyObject]?)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
}

struct OTMStudentSingleton {
    static var sharedInstance = OTMStudent()
}
extension OTMStudent {
    class func thisUser() -> OTMStudent {
        return OTMStudentSingleton.sharedInstance
    }

    class func fillUserFromJson(results: AnyObject?) {
        let shared = OTMStudent.thisUser()
        // if come from query locations
        if let _results = results?.valueForKey("results") as? [AnyObject] {
            let sorted = NSOrderedSet(array: _results)
            /*NOTE: if the user is a udacity member but not a student , we won't get any results
            even though the login passed 
            */
            if sorted.count > 0 {
            let latest = sorted.lastObject as! [String: AnyObject] // most currently updated
            OTMStudentSingleton.sharedInstance = OTMStudent(dictionary: latest)
            }
        }
        // if the response from query public data 
        // to make sure to get user data as last name or first name
        // which means user has no previous location
        if let user = results!.valueForKey(OTMUdacityClient.JSONResponseKeys.user) as? [String: AnyObject],
            key = user[OTMUdacityClient.JSONResponseKeys.key] as? String,
            fname = user[OTMUdacityClient.JSONResponseKeys.first_name] as? String
            ,lname = user[OTMUdacityClient.JSONResponseKeys.last_name] as? String{
                shared.uniqueKey = key
                shared.firstName = fname
                shared.lastName = lname
        }


    }

    class func checkIfUserHasAlreadyALocation() -> Bool{
        let user = OTMStudent.thisUser()
        var haspreviousLocation = false
        if let lat = user.latitude {
            if lat != 0 {
                //this user has a previous location
                //ask if he wants to update
                haspreviousLocation = true
            }
        }
        return haspreviousLocation
    }

}
