//
//  SecondViewController.swift
//  GasStats
//
//  Created by CSSE Department on 1/28/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

import UIKit

class HistoryViewController: SuperViewController, UITableViewDelegate, UITableViewDataSource {
	let fuelLogCellId = "FuelLogCell"
	let noLogsCellId = "NoLogsCell"
	let loadingLogsCellId = "LoadingLogsCell"
	let carRecordCellId = "CarRecordCell"
	let noRecordsCellId = "NoRecordsCell"
	let loadingRecordsCellId = "LoadingRecordsCell"
	let fuelLogSegueId = "FuelLogSegue"
    
	@IBOutlet weak var logTable: UITableView!
	@IBOutlet weak var recordTable: UITableView!
	
	var logQueryComplete = false
	var recordQueryComplete = false
	var cars = [GTLGasstatsCar]()
	var carIdsWithLogs = [NSNumber]()
	var carsWithLogs = [GTLGasstatsCar]()
	var records = [GTLGasstatsTankRecord]()
	
	// everytime the user sees this page
	override func viewWillAppear(animated: Bool) {
		carIdsWithLogs = [NSNumber]()
		carsWithLogs = [GTLGasstatsCar]()
		_populateLogTable()
	}
	
	// the first time the user sees this page
    override func viewDidLoad() {
        super.viewDidLoad()
		logTable.delegate = self
		logTable.dataSource = self
		recordTable.delegate = self
		recordTable.dataSource = self
    }
	
	// MARK: - Table View Methods
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if(tableView.tag == 0){
			return max(1, carsWithLogs.count)
		}else{
			return max(1, records.count)
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: UITableViewCell!
		
		if(tableView.tag == 0){
			if(self.carsWithLogs.count == 0){
				if(self.logQueryComplete == false){
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
		}else if(tableView.tag == 1){
			if(self.records.count == 0){
				if(self.recordQueryComplete == false){
					cell = recordTable.dequeueReusableCellWithIdentifier(loadingRecordsCellId, forIndexPath: indexPath) as UITableViewCell
					
					let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
					cell.accessoryView = spinner
					spinner.startAnimating()
				}else{
					cell = recordTable.dequeueReusableCellWithIdentifier(noRecordsCellId, forIndexPath: indexPath) as UITableViewCell
				}
			}else{
				let record = records[indexPath.row]
				let carid = record.carId
				var car = GTLGasstatsCar()
				if(cars.count != 0){
					car = cars[carid.integerValue]
				}

				cell = recordTable.dequeueReusableCellWithIdentifier(carRecordCellId, forIndexPath: indexPath) as UITableViewCell
				cell.textLabel?.text = "\(car.year) \(car.make) \(car.model)"
				cell.detailTextLabel?.text = "Best: \(record.bestTank), Avg: \(record.avgTank), Last: \(record.lastTank)"
			}
		}
		
		return cell
	}
	
	// MARK: - Private Helper Methods
	func _populateLogTable(){
		logQueryComplete = false
		recordQueryComplete = false
		logTable.reloadData()	// show loading cell
		recordTable.reloadData() // show loading cell
		_queryForLogs()
		_queryForRecords()
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
							self.logQueryComplete = true
							self.logTable.reloadData()
						}else{
							i++
						}}})
			}})
	}
	
	func _queryForRecords(){
		let query = GTLQueryGasstats.queryForTankrecordListByUser() as GTLQueryGasstats
		query.limit = 99
		query.userId = self.user_id.longLongValue
		query.order = "car_id"
		
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true
		service.executeQuery(query, completionHandler: { (ticket, response, error) -> Void in
			UIApplication.sharedApplication().networkActivityIndicatorVisible = false
			
			if error != nil {
				self._showErrorDialog(error!)
			} else {
				let recordCollection = response as GTLGasstatsTankRecordCollection
				if recordCollection.items() != nil{
					self.records = recordCollection.items() as [GTLGasstatsTankRecord]
				}
				self.recordQueryComplete = true
				self.recordTable.reloadData()
			}
		})
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if(segue.identifier == fuelLogSegueId){
			if let indexpath = self.logTable.indexPathForSelectedRow(){
				let nextVc = segue.destinationViewController as CarFuelLogViewController
				let car = self.carsWithLogs[indexpath.row]
				nextVc.carId = car.carId
				nextVc.carName = "\(car.year) \(car.make) \(car.model)"
				nextVc.user_id = self.user_id
			}
		}
	}
}

