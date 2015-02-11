//
//  AccountViewController.swift
//  GasStats
//
//  Created by Grant Smith on 01/30/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

import UIKit

class AccountViewController: SuperViewController {
    
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		_queryForDriverInfo()
    }
	
	func _queryForDriverInfo(){
		let query = GTLQueryGasstats.queryForDriverList() as GTLQueryGasstats
		query.order = "user_id"
		
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true
		
		service.executeQuery(query, completionHandler: { (ticket, response, error) -> Void in
			UIApplication.sharedApplication().networkActivityIndicatorVisible = false
			self.initialQueryComplete = true
			
			if error != nil {
				self._showErrorDialog(error!)
			} else {
				let userCollection = response as GTLGasstatsDriverCollection
				if userCollection.items() != nil{
					let currentUser = userCollection.itemAtIndex(self.user_id.unsignedLongValue) as GTLGasstatsDriver
					
					self.usernameLabel.text = currentUser.username
					self.emailLabel.text = currentUser.email
				}
			}
		})
	}
}
