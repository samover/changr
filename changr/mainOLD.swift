//
//  main.swift
//  changr
//
//  Created by Samuel Overloop on 31/12/15.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

if(NSProcessInfo.processInfo().arguments.contains("TESTING")) {
    
    UIApplicationMain(Process.argc, Process.unsafeArgv, NSStringFromClass(UIApplication), NSStringFromClass(TestingAppDelegate))
    
} else {
    
    UIApplicationMain(Process.argc, Process.unsafeArgv, NSStringFromClass(UIApplication), NSStringFromClass(AppDelegate))

}