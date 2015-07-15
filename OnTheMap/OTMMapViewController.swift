//
//  OTMMapViewController.swift
//  OnTheMap
//
//  Created by Moath_Othman on 6/14/15.
//  Copyright (c) 2015 Moba. All rights reserved.
//
import MapKit
import UIKit

class OTMMapViewController: UIViewController, MKMapViewDelegate {
    var _students : [OTMStudent]?
    var students : [OTMStudent]? {
        get{
            return _students
        }
        set {
            _students = newValue
            mapView.addAnnotations(students)

        }
    }
    var _thisUser:OTMStudent!
    var thisUser: OTMStudent {
        get {
            return self._thisUser
        }
        set {
            let initialLocation = CLLocation(latitude: newValue.latitude!, longitude: newValue.longitude!)
            centerMapOnLocation(initialLocation)
            mapView.addAnnotation(newValue)
            self._thisUser = newValue
        }
    }

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(animated: Bool) {

        mapView.delegate = self
    }
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 200.0, regionRadius * 200.0)
        mapView.setRegion(coordinateRegion, animated: true)
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
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!,
        calloutAccessoryControlTapped control: UIControl!) {
            let location = view.annotation as! OTMStudent
            let url = NSURL(string: location.mediaURL!)
            UIApplication.sharedApplication().openURL(url!)
    }
}
