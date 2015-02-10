//
//  GasStatsTabBarViewController.swift
//  GasStats
//
//  Created by CSSE Department on 2/8/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

import UIKit

class GasStatsTabBarViewController: UITabBarController, UITabBarControllerDelegate {
	var user_id: NSNumber = 23
	var managedObjectContext: NSManagedObjectContext?
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        println("tab vc\(user_id)")
        // Do any additional setup after loading the view.
    }

    func tabBarController(tabBarController: UITabBarController, willBeginCustomizingViewControllers viewControllers: [AnyObject]) {
//        var firstVC = self.viewControllers![0] as FuelUpViewController
//        firstVC.user_id = self.user_id
//        var secondVC = self.viewControllers![1] as HistoryViewController
//        secondVC.user_id = self.user_id
//        var thirdVC = self.viewControllers![2] as GarageViewController
//        thirdVC.user_id = self.user_id
//        var fourthVC = self.viewControllers![3] as CompeteViewController
//        fourthVC.user_id = self.user_id
//        var fifthVC = self.viewControllers![4] as AccountViewController
//        fifthVC.user_id = self.user_id
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        var firstVC = self.viewControllers![0] as FuelUpViewController
        firstVC.user_id = self.user_id
        var secondVC = self.viewControllers![1] as HistoryViewController
        secondVC.user_id = self.user_id
        var thirdVC = self.viewControllers![2] as GarageViewController
        thirdVC.user_id = self.user_id
        var fourthVC = self.viewControllers![3] as CompeteViewController
        fourthVC.user_id = self.user_id
        var fifthVC = self.viewControllers![4] as AccountViewController
        fifthVC.user_id = self.user_id
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    
    

}
