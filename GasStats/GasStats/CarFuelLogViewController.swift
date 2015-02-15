//
//  CarFuelLogViewController.swift
//  GasStats
//
//  Created by CSSE Department on 1/30/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

import UIKit

class CarFuelLogViewController: SuperViewController, UITableViewDataSource, UITableViewDelegate {
	let headingCellId = "HeadingCell"
	let logCellId = "LogCell"
	let loadingLogsCellId = "LoadingLogsCell"
    
	@IBOutlet weak var carNameLabel: UILabel!
	@IBOutlet weak var logTable: UITableView!
	
	var carId: NSNumber?
	var carName: String?
	var logs = [GTLGasstatsGasStat]()
	var logStrings = [String]()
	var queryComplete = false
	
	override func viewWillAppear(animated: Bool) {
		self.carNameLabel.text = carName
		self.logs = [GTLGasstatsGasStat]()
		self.logStrings = [String]()
		self.queryComplete = false
		_queryForLogs()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.logTable.delegate = self
		self.logTable.dataSource = self
    }
	
	// MARK: - Table View Methods
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return max(1, self.logs.count)
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: UITableViewCell!
		
		if(self.logs.count == 0){
			if(!self.queryComplete){
				cell = logTable.dequeueReusableCellWithIdentifier(loadingLogsCellId, forIndexPath: indexPath) as UITableViewCell

				let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
				cell.accessoryView = spinner
				spinner.startAnimating()
			}
		}else{
			let log = logs[indexPath.row]
			var dateFormatter = NSDateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
			
			let date = dateFormatter.dateFromString(log.createDateTime)
			
			dateFormatter.dateFormat = "EE, MMM dd, yyyy 'at' H:mm a"
			let dateString = dateFormatter.stringFromDate(date!)
			
			cell = logTable.dequeueReusableCellWithIdentifier(logCellId, forIndexPath: indexPath) as UITableViewCell
			cell.textLabel?.text = String(format: "%.2f MPG", log.mpg.doubleValue)
			cell.detailTextLabel?.text = dateString
		}
		
		return cell
	}
	
	// MARK: - Private Helper Methods
	func _queryForLogs(){
		let query = GTLQueryGasstats.queryForGasstatListByCarUser() as GTLQueryGasstats
		query.userId = self.user_id.longLongValue
		query.carId = self.carId!.longLongValue
		query.order = "create_date_time"
		
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true
		service.executeQuery(query, completionHandler: { (ticket, response, e) -> Void in
			UIApplication.sharedApplication().networkActivityIndicatorVisible = false

			if e != nil {
				self._showErrorDialog(e!)
			} else {
				let logCollection = response as GTLGasstatsGasStatCollection
				if logCollection.items() != nil{
					self.logs = logCollection.items() as [GTLGasstatsGasStat]
//					self._generateCellStrings()
				}
				self.queryComplete = true
				self.logTable.reloadData()
			}
		})
	}
	
//	func _generateCellStrings(){
//		
//	}
}
