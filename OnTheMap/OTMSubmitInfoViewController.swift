//
//  OTMSubmitInfoViewController.swift
//  OnTheMap
//
//  Created by Moath_Othman on 6/21/15.
//  Copyright (c) 2015 Moba. All rights reserved.
//

import UIKit
import MapKit

class OTMSubmitInfoViewController: UIViewController, MKMapViewDelegate, UITextViewDelegate {
    let initialLinkTextViewText = "Enter a Link to Share Here"
    @IBOutlet weak var mapView: MKMapView!
    var locationCoordinates: CLLocation = CLLocation()
    @IBOutlet weak var linkTextField: UITextView!
    var student:OTMStudent {
        get{
            var _strudent = OTMStudent.thisUser()
            _strudent.mediaURL = linkTextField.text
            _strudent.latitude = locationCoordinates.coordinate.latitude
            _strudent.longitude = locationCoordinates.coordinate.longitude
            return _strudent
        }
    }
    var mapString: String = String()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(animated: Bool) {
        let initialLocation = locationCoordinates
        let regionRadius: CLLocationDistance = 100
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                regionRadius * 100.0, regionRadius * 100.0)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        mapView.addAnnotation(student)
        centerMapOnLocation(initialLocation)
        mapView.delegate = self
    }

    @IBAction func submitLocation(sender: AnyObject) {
        if !validateLink(self.linkTextField.text) {
            return
        }
        MOHUD.show("Submitting")
        // Check if the user overwriting
        if isTheUserOverwritingHisOldLocation {
            OTMParseClient.sharedInstance().updateStudentLocation(student.objectId!,uniqueKey:student.uniqueKey!, firstname: student.firstName!, lastname: student.lastName!, mapString: self.mapString, mediaUrl: student.mediaURL!, latitude: locationCoordinates.coordinate.latitude, longitude: locationCoordinates.coordinate.longitude) { (response, error) -> Void in
                if let err: NSError = error {
                    MOHUD.showWithError(err.localizedDescription)
                } else {
                    self.cancel(UIButton())
                }
                MOHUD.showSuccess("User Location is updated",delay: 10)
            }
            return
        }
        // New Location
        OTMParseClient.sharedInstance().postStudentLocation(student.uniqueKey!, firstname: student.firstName!, lastname: student.lastName!, mapString: self.mapString, mediaUrl: student.mediaURL!, latitude: locationCoordinates.coordinate.latitude, longitude: locationCoordinates.coordinate.longitude) { (response, error) -> Void in
            if let err: NSError = error {
                MOHUD.showWithError(err.localizedDescription)
            } else {
                self.cancel(UIButton())
            }
            MOHUD.showSuccess("User Location is created")
        }
    }
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? OTMStudent {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
            }
            return view
        }
        return nil
    }

    @IBAction func tapOnView(sender: AnyObject) {
        resignKeyboard()
    }
    func resignKeyboard() {
        self.linkTextField.resignFirstResponder()
        if linkTextField.text == "" {
            linkTextField.text = initialLinkTextViewText
        }
    }
    //MARK: TextView Delegate
    func textViewDidEndEditing(textView: UITextView) {
       resignKeyboard()
    }
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        textView.textAlignment = NSTextAlignment.Center
        return true
    }
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if textView.text == initialLinkTextViewText {
            textView.text = ""
            textView.textAlignment = NSTextAlignment.Left
        }
        return true
    }

    func textViewDidChange(textView: UITextView) {
        textView.textAlignment = NSTextAlignment.Left
    }
    //MARK:Helper
    func validateLink(link: String) -> Bool{
        if link.hasPrefix("http://") || link.hasPrefix("https://") {
            return true
        } else {
            MOHUD.showWithError("The URL you chose is not correct, It should start with http:// or https://")
            return false
        }
    }
}
