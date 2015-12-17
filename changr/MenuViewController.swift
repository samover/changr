 //
//  MenuViewController.swift
//  changr
//
//  Created by mahmud hussain on 17/12/2015.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    // MARK: Properties
    var menuItems = [MenuItems]()
    
    
    // MARK: LiefeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let icon1 = UIImage(named: "settings")!
        let item1 = MenuItems(title: "Settings", icon: icon1)!

        let icon2 = UIImage(named: "profile")!
        let item2 = MenuItems(title: "Profile", icon: icon2)!
        
        let icon3 = UIImage(named: "history")!
        let item3 = MenuItems(title: "History", icon: icon3)!
        
        menuItems += [item1, item2, item3]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Table Functions
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let menuCell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuTableViewCell
    
        menuCell.menuItemLabel.text = menuItems[indexPath.row].title
        menuCell.menuItemIcon.image = menuItems[indexPath.row].icon
        
        return menuCell 
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
