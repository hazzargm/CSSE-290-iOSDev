//
//  CompeteViewController.swift
//  GasStats
//
//  Created by Grant Smith on 01/30/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

import UIKit

class CompeteViewController: SuperViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    let competeCellId = "CompeteCell"
	let noRecordsCellId = "NoRecordsCell"
	let loadingRecordsCellId = "LoadingRecordsCell"
    
	@IBOutlet weak var pickerView: UIPickerView!
	@IBOutlet weak var recordTable: UITableView!

	var records = [GTLGasstatsTankRecord]()
	var epaCars = [GTLGasstatsEpaCar]()
	var years = NSMutableArray()
	var makes = NSMutableArray()
	var models = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
		self.pickerView.delegate = self
		self.pickerView.dataSource = self
		self.recordTable.delegate = self
		self.recordTable.dataSource = self
		self._queryForEpaCars()
		self._queryForRecords()
    }

	// MARK: - PickerView Methods
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 3
	}

	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		switch(component){
		case 0:
			return years.count
		case 1:
			return makes.count
		default:
			return models.count
		}
	}

	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
		if epaCars.count != 0 {
			if component == 2 && models.count > 0{
				return "\(models[row])"
			}
			if component == 1 && makes.count > 0{
				return "\(makes[row])"
			}
			if years.count > 0 {
				return "\(years[row])"
			}
		}
		return ""
	}

	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if component == 0 {
			reloadMakeColumn()
			self.pickerView.reloadComponent(1)
			reloadModelColumn()
			self.pickerView.reloadComponent(2)
		} else if component == 1 {
			reloadModelColumn()
			self.pickerView.reloadComponent(2)
		}
		self._queryForRecords()
	}

	func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
		switch (component) {
		case 0:
			return 61.0
		case 1:
			return 80.0
		default:
			return 120.0
		}
	}

	// MARK: - Table View Methods
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return max(1, records.count)
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: UITableViewCell!

		if(records.count == 0){
			if(self.initialQueryComplete == false){
				cell = recordTable.dequeueReusableCellWithIdentifier(loadingRecordsCellId, forIndexPath: indexPath) as UITableViewCell

				let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
				cell.accessoryView = spinner
				spinner.startAnimating()
			}else{
				cell = recordTable.dequeueReusableCellWithIdentifier(noRecordsCellId, forIndexPath: indexPath) as UITableViewCell
			}
		}else{
			let record = records[indexPath.row]
			cell = recordTable.dequeueReusableCellWithIdentifier(competeCellId, forIndexPath: indexPath) as UITableViewCell
			cell.textLabel?.text = "\(record.bestTank) MPG"
		}

		return cell
	}

	// MARK: - Private Helper Methods
	func _queryForRecords(){
		if(!(years.count == 0 || makes.count == 0 || models.count == 0)){
			self.records = [GTLGasstatsTankRecord]()
			let query = GTLQueryGasstats.queryForTankrecordListByYearMakeModel() as GTLQueryGasstats
			query.limit = 99
			query.order = "best_tank"

			query.year = self.years.objectAtIndex(pickerView.selectedRowInComponent(0)).longLongValue
			query.make = self.makes.objectAtIndex(pickerView.selectedRowInComponent(1)) as NSString
			query.model = self.models.objectAtIndex(pickerView.selectedRowInComponent(2)) as NSString

			UIApplication.sharedApplication().networkActivityIndicatorVisible = true
			service.executeQuery(query, completionHandler: { (ticket, response, e) -> Void in
				UIApplication.sharedApplication().networkActivityIndicatorVisible = false
				self.initialQueryComplete = true

				if(e != nil){
					self._showErrorDialog(e)
				}else{
					let recordCollection = response as GTLGasstatsTankRecordCollection
					if recordCollection.items() != nil{
						self.records = recordCollection.items() as [GTLGasstatsTankRecord]
					}
				}
				self.recordTable.reloadData()
			})
		}
	}

	func _queryForEpaCars(){
		let query = GTLQueryGasstats.queryForEpacarList() as GTLQueryGasstats
		query.limit = 99
		query.order = "year"
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true
		service.executeQuery(query, completionHandler: { (ticket, response, error) -> Void in
			UIApplication.sharedApplication().networkActivityIndicatorVisible = false
			self.initialQueryComplete = true
			if error != nil {
				self._showErrorDialog(error!)
			} else {
				let carCollection = response as GTLGasstatsEpaCarCollection
				if carCollection.items() != nil{
					self.epaCars = carCollection.items() as [GTLGasstatsEpaCar]
				}
			}
			self.loadYearColumn()
			self.reloadMakeColumn()
			self.reloadModelColumn()
			self.pickerView.reloadAllComponents()
			self._queryForRecords()
		})
	}

	func reloadMakeColumn() {
		makes = NSMutableArray()
		var selectedYearIndex = pickerView.selectedRowInComponent(0)
		var i = 0
		for i = 0; i < epaCars.count; i++ {
			if epaCars[i].year == years.objectAtIndex(selectedYearIndex) as? NSNumber{
				if !makes.containsObject(epaCars[i].make) {
					makes.addObject(epaCars[i].make)
				}
			}
		}
	}

	func reloadModelColumn() {
		models = NSMutableArray()
		var selectedYearIndex = pickerView.selectedRowInComponent(0)
		var selectedMakeIndex = pickerView.selectedRowInComponent(1)
		var i = 0
		for i = 0; i < epaCars.count; i++ {
			if (epaCars[i].year == years.objectAtIndex(selectedYearIndex) as? NSNumber) &&
				(epaCars[i].make == makes.objectAtIndex(selectedMakeIndex) as NSString) {
					if !models.containsObject(epaCars[i].model) {
						models.addObject(epaCars[i].model)

					}
			}
		}
	}

	func loadYearColumn() {
		var i = 0
		for i = 0; i < epaCars.count; i++ {
			if !years.containsObject(epaCars[i].year) {
				years.insertObject(epaCars[i].year, atIndex: 0)
			}
		}
	}
}
