//
//  ViewController.swift
//  changr
//
//  Created by Samuel Overloop on 16/12/15.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

// NOTE TO SELF: Do not use appdelegate for firebase operation
// rather have a model that can be mocked 

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    // MARK: Properties
    var appDelegate: AppDelegate!
    let firebase = FirebaseWrapper()
    let homelessNews = ["The Guardian", "The Big Issue", "Crisis.ORG"]
    let ResourceCellIdentifier = "ResourceCell"
    
    struct Resource {
        var name: String
        var link: String
        var image: String
    }
    
    let ResourceList = [
        Resource(name: "Crisis UK", link: "http://www.crisis.org.uk/", image: "crisis-logo"),
        Resource(name: "Shelter UK", link: "http://www.shelter.org.uk/", image: "shelter-logo"),
        Resource(name: "Homeless UK", link: "http://www.crisis.org.uk/", image: "homeless-logo"),
        Resource(name: "Shelter From The Storm", link: "http://www.sfts.org.uk/", image: "storm-logo")
    ]
    
    
    // MARK: Outlets

    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ResourceList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ResourceCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        let row = indexPath.row
        cell.textLabel?.text = ResourceList[row].name
        cell.imageView?.image = UIImage(named: ResourceList[row].image)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        UIApplication.sharedApplication().openURL(NSURL(string:ResourceList[row].link)!)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Actions
    @IBAction func menuButton(sender: AnyObject) {
        appDelegate.centerContainer!.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
    @IBAction func logoutButton(sender: AnyObject) {
        firebase.ref.unauth()
        appDelegate.window?.rootViewController = appDelegate.rootController
        appDelegate.window!.makeKeyAndVisible()
    }

}

