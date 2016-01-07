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
    var appDelegate: AppDelegate!
    var centerViewController: ViewController!
    var settingsViewController: SettingsViewController!
    var profileViewController: ProfileViewController!
    var historyViewController: HistoryViewController!
    var resourcesViewController: ResourcesViewController!
    var settingsNavController: UINavigationController!
    var centerNavController: UINavigationController!
    var profileNavController: UINavigationController!
    var historyNavController: UINavigationController!
    var resourcesNavController: UINavigationController!
    var menuItems = [MenuItems]()

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        centerViewController = storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        settingsViewController = storyboard?.instantiateViewControllerWithIdentifier("SettingsViewController") as! SettingsViewController
        profileViewController = storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        historyViewController = storyboard?.instantiateViewControllerWithIdentifier("HistoryViewController") as! HistoryViewController
        resourcesViewController = storyboard?.instantiateViewControllerWithIdentifier("ResourcesViewController") as! ResourcesViewController
        
        let icon0 = UIImage(named: "home")!
        let item0 = MenuItems(title: "Home", icon: icon0)!
        
        let icon1 = UIImage(named: "settings")!
        let item1 = MenuItems(title: "Settings", icon: icon1)!

        let icon2 = UIImage(named: "history")!
        let item2 = MenuItems(title: "History", icon: icon2)!
        
        let icon3 = UIImage(named: "resources")!
        let item3 = MenuItems(title: "Resources", icon: icon3)!

        let icon4 = UIImage(named: "profile")!
        let item4 = MenuItems(title: "Profile", icon: icon4)!
        
        menuItems += [item0, item1, item2, item3, item4]
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
        
        switch(indexPath.row)
        {
            
        case 0:
            centerNavController = UINavigationController(rootViewController: centerViewController)
            appDelegate.centerContainer!.centerViewController = centerNavController
            break;
            
        case 1:
            settingsNavController = UINavigationController(rootViewController: settingsViewController)
            appDelegate.centerContainer!.centerViewController = settingsNavController
            break;

        case 2:
            historyNavController = UINavigationController(rootViewController: historyViewController)
            appDelegate.centerContainer!.centerViewController = historyNavController
            break;

        case 3:
            resourcesNavController = UINavigationController(rootViewController: resourcesViewController)
            appDelegate.centerContainer!.centerViewController = resourcesNavController
            break;

        case 4:
            profileNavController = UINavigationController(rootViewController: profileViewController)
            appDelegate.centerContainer!.centerViewController = profileNavController
            break;

        default:
            print("\(menuItems[indexPath.row]) is selected");
        }
        
        appDelegate.centerContainer!.toggleDrawerSide(.Left, animated: true, completion: nil)
    }

}
