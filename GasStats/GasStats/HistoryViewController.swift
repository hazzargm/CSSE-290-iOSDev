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
	var fuelLogCell = "FuelLogCell"
	var noLogsCell = "NoLogsCell"
    var carHistoryCellIdentifier = "CarHistoryCellIdentifier"
    var carRecordsCellIdentifier = "CarRecordsCellIdentifier"
    
	@IBOutlet weak var logTable: UITableView!
	
//	var logsRefreshControl = UIRefreshControl()
	var cars = [GTLGasstatsCar]()
	var carIdsWithLogs = [NSNumber]()
	var carsWithLogs = [GTLGasstatsCar]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		logTable.delegate = self
		logTable.dataSource = self
		_populateLogTable()
    }
	
	// MARK: - Table View Methods
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return carsWithLogs.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: UITableViewCell!
		
		if(self.carsWithLogs.count == 0){
			cell = logTable.dequeueReusableCellWithIdentifier(noLogsCell, forIndexPath: indexPath) as UITableViewCell
		}else{
			let car = carsWithLogs[indexPath.row]
			cell = logTable.dequeueReusableCellWithIdentifier(fuelLogCell, forIndexPath: indexPath) as UITableViewCell
			cell.textLabel?.text = "\(car.year) \(car.make) \(car.model)"
		}
		
		return cell
	}
	
	func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
		//
	}
	
	// MARK: - Private Helper Methods
	func _populateLogTable(){
		_queryForCars()
	}
	
	func _queryForCars(){
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

