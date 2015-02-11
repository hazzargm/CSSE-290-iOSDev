//
//  GasStatsTabBarViewController.swift
//  GasStats
//
//  Created by CSSE Department on 2/8/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

import UIKit

class GasStatsTabBarViewController: UITabBarController, UITabBarControllerDelegate {
	var user_id = 23
	var managedObjectContext: NSManagedObjectContext?
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    func tabBarController(tabBarController: UITabBarController, willBeginCustomizingViewControllers viewControllers: [AnyObject]) {
		//
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
		//
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		(segue.destinationViewController as SuperViewController).user_id = user_id
    }
}
