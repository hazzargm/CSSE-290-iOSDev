//
//  ThirdViewController.swift
//  GasStats
//
//  Created by Grant Smith on 01/30/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

import UIKit

class GarageViewController: UIViewController {
    var user_id: NSNumber = 0
    var showCarSequeIdentifier = "ShowCarSequeIdentifier"
    var carCellIdentifer = "CarCellIdentifier"
    
	@IBOutlet weak var newCarPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        println("garage vc\(user_id)")

    }
    
	@IBAction func pressedAddCar(sender: AnyObject) {
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
