//
//  ResourcesViewController.swift
//  changr
//
//  Created by Fergus Lemon on 07/01/2016.
//  Copyright © 2016 Samuel Overloop. All rights reserved.
//

import UIKit

class ResourcesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!


    // MARK: Properties
    var appDelegate: AppDelegate!
    var firebase: FirebaseWrapper!

    struct Resource {
        var name: String
        var link: String
        var image: String
    }

    let homelessNews = ["The Guardian", "The Big Issue", "Crisis.ORG"]
    let ResourceCellIdentifier = "ResourceCell"

    let ResourceList = [
        Resource(name: "Crisis UK", link: "http://www.crisis.org.uk/", image: "crisis-logo"),
        Resource(name: "Shelter UK", link: "http://www.shelter.org.uk/", image: "shelter-logo"),
        Resource(name: "Homeless UK", link: "http://www.crisis.org.uk/", image: "homeless-logo"),
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        tableView.delegate = self
        tableView.dataSource = self
        firebase = appDelegate.firebase
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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



    // MARK: Actions
    @IBAction func menuButton(sender: AnyObject) {
        appDelegate.centerContainer!.toggleDrawerSide(.Left, animated: true, completion: nil)
    }

    @IBAction func logoutButton(sender: AnyObject) {
        firebase.ref.unauth()
        appDelegate.window?.rootViewController = appDelegate.rootController
        appDelegate.window!.makeKeyAndVisible()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
