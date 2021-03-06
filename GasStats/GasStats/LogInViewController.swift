//
//  LogInViewController.swift
//  GasStats
//
//  Created by CSSE Department on 2/8/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

import UIKit
import CoreData

class LogInViewController: SuperViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var logInSegueIdentifier = "LogInSegue"
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pressedLogInButton(sender: AnyObject) {
        //Query info for user id
//        let newCurrent = NSEntityDescription.insertNewObjectForEntityForName("Current", inManagedObjectContext: self.managedObjectContext!) as Current
//        newCurrent.user_id = 0
//        newCurrent.car_id = 0
//        newCurrent.loggedIn = true
//        self.saveManagedObjectContext()
//        let fetchRequest = NSFetchRequest(entityName: "Current")
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "user_id", ascending: false)]
//        var error: NSError? = nil
//        var currents = managedObjectContext?.executeFetchRequest(fetchRequest, error: &error) as [Current]
//        user_id = currents[0].user_id.integerValue
//        car_id = currents[0].car_id.integerValue
//        if error != nil
//        {
//            println("Unresolved Core Data error \(error?.userInfo)")
//            abort()
//        }
        
    }
    
    // MARK: -CoreData
    
    func saveManagedObjectContext(){
        var error: NSError? = nil
        managedObjectContext!.save(&error)
        if error != nil{
            println("Unresolved Core Data error \(error?.userInfo)")
            abort()
		}
	}
    
    // MARK: - Navigation
	
	override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
		if(usernameTextField.text.isEmpty){
			return false
		}
		if(passwordTextField.text.isEmpty){
			return false
		}
		return true
	}

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == logInSegueIdentifier{
			let nextVc = segue.destinationViewController as GasStatsTabBarViewController
			nextVc.user_id = user_id
			nextVc.managedObjectContext = managedObjectContext
		}
	}
}