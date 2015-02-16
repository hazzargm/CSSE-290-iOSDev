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
    @IBOutlet weak var topLabelsView: UIView!
    @IBOutlet weak var bottomLabelsView: UIView!
    @IBOutlet weak var bestTankLabel: UILabel!
    @IBOutlet weak var lastTankLabel: UILabel!
    @IBOutlet weak var avgTankLabel: UILabel!
    @IBOutlet weak var gasBillLabel: UILabel!
    
    @IBOutlet weak var logItButton: UIButton!
    
    @IBOutlet weak var carPicker: UIPickerView!
	
    var cars = [GTLGasstatsCar]()
    var tankRecord = GTLGasstatsTankRecord()
	var _refreshControl : UIRefreshControl?
	var mpg: Double = 0.0
    var statCount: NSNumber = 0
	
	override func viewWillAppear(animated: Bool) {
		_queryForCars()
        _queryForGasstats(NSNumber.init(integer: 0), userId: self.user_id)
        _queryForTankRecord(NSNumber.init(integer: 0), userID: self.user_id)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        carPicker.delegate = self
        carPicker.dataSource = self
    }
    
    @IBAction func pressedLogIt(sender: AnyObject){
        _queryForGasstats(NSNumber.init(integer: carPicker.selectedRowInComponent(0)), userId: self.user_id)
        _queryForTankRecord(NSNumber.init(integer: carPicker.selectedRowInComponent(0)), userID: tankRecord.userId)
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
        self.updateTankRecord()
        updateButtonsAndRecords(false)
    }
    
	@IBAction func milesChanged(sender: AnyObject) {
		updateLabel()
        updateButtonsAndRecords(true)
    }
	
	@IBAction func gallonsChanged(sender: AnyObject) {
		updateLabel()
        updateButtonsAndRecords(true)
	}
	
    @IBAction func costChanged(sender: AnyObject) {
        updateButtonsAndRecords(true)
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
    
    func _queryForTankRecord(carID: NSNumber, userID: NSNumber) {
        let query = GTLQueryGasstats.queryForTankrecordListByCarUser() as GTLQueryGasstats
        query.limit = 1
        query.userId = userID.longLongValue
        query.carId = carID.longLongValue
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        service.executeQuery(query, completionHandler: { (ticket, response, error) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.initialQueryComplete = true
            self._refreshControl?.endRefreshing()
            if error != nil {
                self._showErrorDialog(error!)
            } else {
                let recordCollection = response as GTLGasstatsTankRecordCollection
                if recordCollection.items() != nil {
                    var records = recordCollection.items() as [GTLGasstatsTankRecord]
                    self.tankRecord = records[0]
                } else {
                    self.tankRecord = GTLGasstatsTankRecord()
                    self.tankRecord.avgTank = 0
                    self.tankRecord.bestTank = 0
                    self.tankRecord.lastTank = 0
                    self.tankRecord.carId = carID
                    self.tankRecord.userId = userID
                }
            }
        })
    }
    
    func _insertTankRecord(record: GTLGasstatsTankRecord) {
        let query = GTLQueryGasstats.queryForTankrecordInsertWithObject(record) as GTLQueryGasstats
        if isLocalHostTesting {
            query.JSON = record.JSON
            query.bodyObject = nil
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        service.executeQuery(query, completionHandler: { (ticket, response, error) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if error != nil {
                self._showErrorDialog(error!)
                return
            }
            let returnedRecord = response as GTLGasstatsTankRecord
            record.entityKey = returnedRecord.entityKey
        })
    }
    
    func _queryForGasstats(carId : NSNumber, userId : NSNumber) {
        let query = GTLQueryGasstats.queryForGasstatListByCarUser() as GTLQueryGasstats
        query.userId = userId.longLongValue
        query.carId = carId.longLongValue
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        service.executeQuery(query, completionHandler: { (ticket, response, error) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.initialQueryComplete = true
            self._refreshControl?.endRefreshing()
            if error != nil {
                self._showErrorDialog(error!)
            } else {
                let statCollection = response as GTLGasstatsGasStatCollection
                var stats = [GTLGasstatsGasStat]()
                if statCollection.items() != nil{
                    stats = statCollection.items() as [GTLGasstatsGasStat]
                    self.statCount = NSNumber.init(integer: stats.count)
                }
            }
        })
    }
	
	// MARK: - Picker View Methods
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateButtonsAndRecords(true)
        _queryForGasstats(NSNumber.init(integer: row), userId: self.user_id)
        _queryForTankRecord(NSNumber.init(integer: row), userID: self.user_id)
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
		
		if (miles == 0 || gallons == 0){
			mpg = 0.0
            mpgLabel.text = String(format: "%.2f MPG", mpg)
		} else {
			mpg = miles / gallons
            mpgLabel.text = String(format: "%.2f MPG", mpg)
		}
    }
    
    func updateButtonsAndRecords(editing : Bool) {
        self.logItButton.hidden = !editing
        self.topLabelsView.hidden = editing
        self.topLabelsView.opaque = editing
        self.bottomLabelsView.hidden = editing
        self.bottomLabelsView.opaque = editing
    }
    
    func updateTankRecord() {
        tankRecord.lastTank = NSNumber.init(double: mpg)
        if (tankRecord.bestTank.doubleValue < mpg)
        {
            tankRecord.bestTank = NSNumber.init(double: mpg)
        }
        var total = statCount.doubleValue * tankRecord.avgTank.doubleValue
        total = total + mpg
        var newAvg = total / (statCount.doubleValue + 1)
        tankRecord.avgTank = NSNumber.init(double: newAvg)
        bestTankLabel.text! = NSString(format: "Best Tank: %.2f", tankRecord.bestTank.doubleValue)
        avgTankLabel.text! = NSString(format: "Avg. Tank: %.2f", tankRecord.avgTank.doubleValue)
        lastTankLabel.text! = NSString(format: "last Tank: %.2f", tankRecord.lastTank.doubleValue)
        gasBillLabel.text! = NSString(format: "Gas Bill: $%.2f", 99.99)
        _insertTankRecord(tankRecord)
    }

}

