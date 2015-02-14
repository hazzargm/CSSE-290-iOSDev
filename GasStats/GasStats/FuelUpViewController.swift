//
//  FirstViewController.swift
//  GasStats
//
//  Created by CSSE Department on 1/28/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

import UIKit
import CoreData

class FuelUpViewController: SuperViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var gallonsTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var milesTextField: UITextField!
    @IBOutlet weak var mpgLabel: UILabel!
    
    @IBOutlet weak var postLogView: UIView!
    @IBOutlet weak var bestTankLabel: UILabel!
    @IBOutlet weak var lastTankLabel: UILabel!
    @IBOutlet weak var avgTankLabel: UILabel!
    @IBOutlet weak var gasBillLabel: UILabel!
    
    @IBOutlet weak var logItButton: UIButton!
    
    @IBOutlet weak var carPicker: UIPickerView!
	
    var cars = [GTLGasstatsCar]()
	var _refreshControl : UIRefreshControl?
	var mpg: Double = 0.0
	
	override func viewWillAppear(animated: Bool) {
		_queryForCars()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        carPicker.delegate = self
        carPicker.dataSource = self
    }
    
    @IBAction func pressedLogIt(sender: AnyObject){
        var miles = (milesTextField.text as NSString).floatValue
        var gallons = (gallonsTextField.text as NSString).floatValue
        var cost = (costTextField.text as NSString).floatValue
        var mpg = miles/gallons
        var gasStat = GTLGasstatsGasStat()
        gasStat.miles = miles
        gasStat.gallons = gallons
        gasStat.cost = cost
        gasStat.mpg = mpg
        gasStat.userId = user_id
        gasStat.carId = carPicker.selectedRowInComponent(0)
        _insertGasStat(gasStat)
    }
    
	@IBAction func milesChanged(sender: AnyObject) {
		updateLabel()
	}
	
	@IBAction func gallonsChanged(sender: AnyObject) {
		updateLabel()
	}
	
    // MARK: - Private Query Methods
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
			self.cars = self.sortCarsByCarId(self.cars)
			self.carPicker.reloadAllComponents()	// refresh data in all components of picker
		})
	}
	
    func _insertGasStat(newGasStat : GTLGasstatsGasStat){
        let query = GTLQueryGasstats.queryForGasstatInsertWithObject(newGasStat) as GTLQueryGasstats
        if isLocalHostTesting {
            query.JSON = newGasStat.JSON
            query.bodyObject = nil
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        service.executeQuery(query, completionHandler: { (ticket, response, error) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if error != nil {
                self._showErrorDialog(error!)
                return
            }
            let returnedGasStat = response as GTLGasstatsGasStat
            newGasStat.entityKey = returnedGasStat.entityKey
        })
    }
	
	// MARK: - Picker View Methods
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		// TODO: set current car to car at position 'row' in array of user's cars
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
		if cars.count != 0{
			return "\(cars[row].year) \(cars[row].make) \(cars[row].model)"
		}
        return nil
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return max(1, cars.count)
	}
    
    func updateLabel(){
		var miles: Double = 0.0
		var gallons: Double = 0.0
		
		if(milesTextField.text.isEmpty){
			miles = 0.0
		}else{
			miles = (milesTextField.text as NSString).doubleValue
		}
		
		if(gallonsTextField.text.isEmpty){
			gallons = 0.0
		}else{
			gallons = (gallonsTextField.text as NSString).doubleValue
		}
		
		if (miles == 0){
			mpg = 0.0
		}else if(gallons == 0){
			mpg = 99.9
		}else{
			mpg = miles / gallons
		}
		
		mpgLabel.text = String(format: "%.2f MPG", mpg)
    }
}

