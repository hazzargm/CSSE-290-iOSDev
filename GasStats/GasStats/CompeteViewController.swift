//
//  CompeteViewController.swift
//  GasStats
//
//  Created by Grant Smith on 01/30/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

import UIKit

class CompeteViewController: UIViewController {

    var user_id: NSNumber = 0
    
    var leaderboardCellIdentifier = "LeaderBoardIdentifier"
    
	@IBOutlet weak var pickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        println("compare vc \(user_id)")

    }
}
