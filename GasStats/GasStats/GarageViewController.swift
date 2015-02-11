//
//  ThirdViewController.swift
//  GasStats
//
//  Created by Grant Smith on 01/30/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

import UIKit

class GarageViewController: SuperViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    let showCarSequeIdentifier = "ShowCarSequeIdentifier"
    let carCellId = "CarCell"
	let noCarsCellId = "NoCarCell"
    
	@IBOutlet weak var newCarPicker: UIPickerView!
	@IBOutlet weak var garageTable: UITableView!
	
	var cars = [GTLGasstatsCar]()
	var _refreshControl : UIRefreshControl?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		_refreshControl = UIRefreshControl()
		_refreshControl?.addTarget(self, action: "_queryForCars", forControlEvents: .ValueChanged)
		garageTable.dataSource = self
		garageTable.delegate = self
		_queryForCars()
    }
    
	@IBAction func pressedAddCar(sender: AnyObject) {
		
	}
	
	// MARK: - PickerView Methods
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		// TODO
		return 0
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		// TODO
		return 0
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
		// TODO
		return ""
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		// TODO
	}
	
	// MARK: - TableView Methods
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return max(1, self.cars.count)
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell: UITableViewCell!
		
		if(self.cars.count == 0){
			cell = garageTable.dequeueReusableCellWithIdentifier(noCarsCellId, forIndexPath: indexPath) as UITableViewCell
		}else{
			let car = cars[indexPath.row]
			cell = garageTable.dequeueReusableCellWithIdentifier(carCellId, forIndexPath: indexPath) as UITableViewCell
			cell.textLabel?.text = "\(car.year) \(car.make) \(car.model)"
		}
		
		return cell
	}
	
	// MARK: - Private Helper Methods
	func _queryForCars(){
		let query = GTLQueryGasstats.queryForCarListByUser() as GTLQueryGasstats
		query.limit = 99
		query.userId = self.user_id.longLongValue
		query.order = "car_id"
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true
		service.executeQuery(query, completionHandler: { (ticket, response, error) -> Void in
			UIApplication.sharedApplication().networkActivityIndicatorVisible = false
			self.initialQueryComplete = true
			self._refreshControl?.endRefreshing()
			if error != nil {
				self._showErrorDialog(error!)
			} else {
				let carCollection = response as GTLGasstatsCarCollection
				if carCollection.items() != nil{
					self.cars = carCollection.items() as [GTLGasstatsCar]
				}
			}
			
			self.garageTable.reloadData()
		})
	}
	
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
