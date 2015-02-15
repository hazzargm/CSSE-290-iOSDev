//
//  CarFuelLogViewController.swift
//  GasStats
//
//  Created by CSSE Department on 1/30/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

import UIKit

class CarFuelLogViewController: SuperViewController {
	var carId: NSNumber?
    
	@IBOutlet weak var carNameLabel: UILabel!
	@IBOutlet weak var recordTable: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
