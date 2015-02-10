//
//  SecondViewController.swift
//  GasStats
//
//  Created by CSSE Department on 1/28/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    var user_id: NSNumber = 0
    var showCarFuelLogSequeIdentifier = "ShowCarFuelLogSequeIdentifier"
    var carHistoryCellIdentifier = "CarHistoryCellIdentifier"
    var carRecordsCellIdentifier = "CarRecordsCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("history vc\(user_id)")

        // Do any additional setup after loading the view, typically from a nib.
    }
}

