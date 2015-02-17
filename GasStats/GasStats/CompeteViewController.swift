//
//  CompeteViewController.swift
//  GasStats
//
//  Created by Grant Smith on 01/30/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

import UIKit

class CompeteViewController: SuperViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let leaderboardCellIdentifier = "LeaderBoardIdentifier"
    
	@IBOutlet weak var pickerView: UIPickerView!

	var epaCars = [GTLGasstatsEpaCar]()
	var years = NSMutableArray()
	var makes = NSMutableArray()
	var models = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
		pickerView.delegate = self
		pickerView.dataSource = self
		self._queryForEpaCars()
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
			pickerView.reloadComponent(1)
			reloadModelColumn()
			pickerView.reloadComponent(2)
		} else if component == 1 {
			reloadModelColumn()
			pickerView.reloadComponent(2)
		}

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

	// MARK: - Private Helper Methods
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
