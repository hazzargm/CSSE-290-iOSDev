//
//  SuperViewController.swift
//  GasStats
//
//  Created by Grant Smith on 02/10/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

import UIKit

class SuperViewController: UIViewController {
	let isLocalHostTesting = false
	let localHostRpcUrl = "http://localhost:8080/_ah/api/rpc?prettyPrint=false"
	
	var user_id: NSNumber = 1
	
	var initialQueryComplete = false

	var service : GTLServiceGasstats {
		if (_service != nil) {
			return _service!
		}
		_service = GTLServiceGasstats()
		if (isLocalHostTesting) {
			_service!.rpcURL = NSURL(string: localHostRpcUrl)
			_service!.fetcherService.allowLocalhostRequest = true
		}
		_service!.retryEnabled = true
		_service!.apiVersion = "v1"
		return _service!
	}
	var _service : GTLServiceGasstats?
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	// MARK: - Private Helper Methods
	func _showErrorDialog(error : NSError) {
		let alertController = UIAlertController(title: "Endpoints Error", message: error.localizedDescription, preferredStyle: .Alert)
		let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
		alertController.addAction(defaultAction)
		presentViewController(alertController, animated: true, completion: nil)
	}
}
