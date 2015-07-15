//
//  OTMLocationPostViewController.swift
//  OnTheMap
//
//  Created by Moath_Othman on 6/20/15.
//  Copyright (c) 2015 Moba. All rights reserved.
//

import UIKit
import CoreLocation

class OTMLocationPostViewController: UIViewController, UITextViewDelegate {
    let initialInputTextViewText = "Enter your location here"
    @IBOutlet weak var inputLocationtextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resignKeyboardgesture(sender: AnyObject) {
        self.inputLocationtextView.resignFirstResponder()
        if self.inputLocationtextView.text == "" {
            self.inputLocationtextView.text = initialInputTextViewText
        }
    }
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in

        })
    }

    @IBAction func findOntheMap(sender: AnyObject) {

        var location = CLGeocoder()
        MOHUD.show("Posting")
        location.geocodeAddressString(inputLocationtextView.text, completionHandler: { (array:[AnyObject]! , error) -> Void in
            if let err = error {
                println("eroro \(err)")
                MOHUD.showWithError("Failed to find the location, please check the spelling", delay: 4)
            }else {
                var place = array.first as! CLPlacemark
                println(place.location)
                var locationsubmit = ViewControllersFactory.make(.submitInfo) as! OTMSubmitInfoViewController
                locationsubmit.locationCoordinates = place.location
                locationsubmit.mapString = self.inputLocationtextView.text
                self.presentViewController(locationsubmit, animated: true) { () -> Void in
                }
                MOHUD.dismiss()

            }
        })

    }

    //MARK: - TextView Delegate
    func textViewDidEndEditing(textView: UITextView) {
        resignKeyboardgesture(textView)
    }
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        textView.textAlignment = NSTextAlignment.Center
                return true
    }
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if textView.text == initialInputTextViewText {
            textView.text = ""
            textView.textAlignment = NSTextAlignment.Left
        }
        return true
    }
    func textViewDidChange(textView: UITextView) {
        textView.textAlignment = NSTextAlignment.Left
    }
}
