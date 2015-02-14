//
//  SecondViewController.swift
//  GasStats
//
//  Created by CSSE Department on 1/28/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

import UIKit

class HistoryViewController: SuperViewController, UITableViewDelegate, UITableViewDataSource {
    var showCarFuelLogSequeIdentifier = "ShowCarFuelLogSequeIdentifier"
	var fuelLogCellId = "FuelLogCell"
	var noLogsCellId = "NoLogsCell"
	var loadingLogsCellId = "LoadingLogsCell"
    
	@IBOutlet weak var logTable: UITableView!
	
	var queryComplete = false
	var cars = [GTLGasstatsCar]()
	var carIdsWithLogs = [NSNumber]()
	var carsWithLogs = [GTLGasstatsCar]()
	
	// everytime the user sees this page
	override func viewWillAppear(animated: Bool) {
		cars = [GTLGasstatsCar]()
		carIdsWithLogs = [NSNumber]()
		carsWithLogs = [GTLGasstatsCar]()
		_populateLogTable()
	}
	
	// the first time the user sees this page
    override func viewDidLoad() {
        super.viewDidLoad()
		logTable.delegate = self
		logTable.dataSource = self
    }
	
	// MARK: - Table View Methods
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return max(1, carsWithLogs.count)
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: UITableViewCell!
		
		if(self.carsWithLogs.count == 0){
			if(self.queryComplete == false){
				cell = logTable.dequeueReusableCellWithIdentifier(loadingLogsCellId, forIndexPath: indexPath) as UITableViewCell
				
				let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
				cell.accessoryView = spinner
				spinner.startAnimating()
			}else{
				cell = logTable.dequeueReusableCellWithIdentifier(noLogsCellId, forIndexPath: indexPath) as UITableViewCell
			}
		}else{
			let car = carsWithLogs[indexPath.row]
			cell = logTable.dequeueReusableCellWithIdentifier(fuelLogCellId, forIndexPath: indexPath) as UITableViewCell
			cell.textLabel?.text = "\(car.year) \(car.make) \(car.model)"
		}
		
		return cell
	}
	
	func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
		//
	}
	
	// MARK: - Private Helper Methods
	func _populateLogTable(){
		queryComplete = false
		logTable.reloadData()	// show loading cell
		_queryForLogs()
	}
	
	func _queryForLogs(){
		let query = GTLQueryGasstats.queryForCarListByUser() as GTLQueryGasstats
		query.limit = 99
		query.userId = self.user_id.longLongValue
		query.order = "car_id"

		UIApplication.sharedApplication().networkActivityIndicatorVisible = true
		service.executeQuery(query, completionHandler: { (ticket, response, error) -> Void in
			UIApplication.sharedApplication().networkActivityIndicatorVisible = false
			
			if error != nil {
				self._showErrorDialog(error!)
			} else {
				let carCollection = response as GTLGasstatsCarCollection
				if carCollection.items() != nil{
					self.cars = carCollection.items() as [GTLGasstatsCar]
				}
			}
			
			var i = 1
			for car in self.cars{
				let query = GTLQueryGasstats.queryForGasstatListByCarUser() as GTLQueryGasstats
				query.limit = 1
				query.carId = car.carId.longLongValue
				query.userId = self.user_id.longLongValue
				
				UIApplication.sharedApplication().networkActivityIndicatorVisible = true
				self.service.executeQuery(query, completionHandler: { (ticket, response, error) -> Void in
					UIApplication.sharedApplication().networkActivityIndicatorVisible = false
					if error != nil{
						self._showErrorDialog(error)
					}else{
						if (response as GTLGasstatsGasStatCollection).items() != nil{
							self.carsWithLogs.append(car)
						}
						if (i == self.cars.count){
							self.queryComplete = true
							self.logTable.reloadData()
						}else{
							i++
						}
					}
				})
			}
		})
	}
}

