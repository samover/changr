//
//  tableViewController.swift
//  changr
//
//  Created by Samuel Overloop on 17/12/15.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import UIKit

class tableViewController: UITableViewController {
    
    var items = [MenuItems]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let icon1 = UIImage(named: "settings")
        let icon2 = UIImage(named: "profile")
        let icon3 = UIImage(named: "history")
        
        let item1 = MenuItems(title: "Settings", icon: icon1)!
        let item2 = MenuItems(title: "Profile", icon: icon2)!
        let item3 = MenuItems(title: "History", icon: icon3)!
        
        items += [item1,item2,item3]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.item == 0 {
            
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("SettingsViewController") as! SettingsViewController
            
            let navigationController = self.mm_drawerController.centerViewController as! UINavigationController
            
            navigationController.viewControllers = [viewController]
            
            self.mm_drawerController.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
        }
        if indexPath.item == 1 {
            
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
            
            let navigationController = self.mm_drawerController.centerViewController as! UINavigationController
            
            navigationController.viewControllers = [viewController]
            
            self.mm_drawerController.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            
        }
        else if indexPath.item == 2 {
            
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("HistoryViewController") as! HistoryViewController
            
            let navigationController = self.mm_drawerController.centerViewController as! UINavigationController
            
            navigationController.viewControllers = [viewController]
            
            self.mm_drawerController.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
        }
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
