//
//  FirstViewController.swift
//  GasStats
//
//  Created by CSSE Department on 1/28/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

import UIKit
import CoreData

let isLocalHostTesting = false
let localHostRpcUrl = "http://localhost:8080/_ah/api/rpc?prettyPrint=false"

class FuelUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

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
	
    var user_id : NSNumber = 0
    
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
    var _refreshControl : UIRefreshControl?
    var cars = [GTLGasstatsCar]()
    var carStrings = NSMutableArray()
    let _pickerData = ["one", "teo"]
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        _refreshControl = UIRefreshControl()
        _refreshControl?.addTarget(self, action: "_queryForCars", forControlEvents: .ValueChanged)
        carPicker.delegate = self
        carPicker.dataSource = self
        _queryForCars()
        println("fuel up vc\(user_id)")

    }
    
    @IBAction func pressedLogIt(sender: AnyObject)
    {
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
        println("\(gasStat.userId)\n")
        gasStat.carId = carPicker.selectedRowInComponent(0)
        println("\(gasStat.carId)")
        _insertGasStat(gasStat)
    }
    
    // MARK: - Private Query Methods
    func _showErrorDialog(error : NSError) {
        let alertController = UIAlertController(title: "Endpoints Error", message: error.localizedDescription, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
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
		//
    }
}

