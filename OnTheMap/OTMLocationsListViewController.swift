//
//  OTMLocationsListViewController.swift
//  OnTheMap
//
//  Created by Moath_Othman on 6/14/15.
//  Copyright (c) 2015 Moba. All rights reserved.
//

import UIKit

class OTMLocationsListViewController: UITableViewController {
    var _students : [OTMStudent]?
    var students : [OTMStudent]? {
        get{
            return _students
        }
        set {
            _students = newValue
            self.tableView.reloadData()
        }
    }
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let s = _students {
            return s.count
        }
        return 0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        let student: OTMStudent = _students![indexPath.row]
        cell.imageView?.image = UIImage(named: "pin")
        cell.textLabel?.text = student.firstName
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student: OTMStudent = _students![indexPath.row]
        let url = NSURL(string:student.mediaURL!)
        if let _url = url {
        UIApplication.sharedApplication().openURL(_url)
        }
    }
}
