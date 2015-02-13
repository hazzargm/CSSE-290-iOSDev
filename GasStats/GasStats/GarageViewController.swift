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
    var epaCars = [GTLGasstatsEpaCar]()
    var years = NSMutableArray()
    var makes = NSMutableArray()
    var models = NSMutableArray()
    
	var _refreshControl : UIRefreshControl?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		_refreshControl = UIRefreshControl()
		_refreshControl?.addTarget(self, action: "_queryForCars", forControlEvents: .ValueChanged)
        _refreshControl?.addTarget(self, action: "_queryForEpaCars", forControlEvents: .ValueChanged)
		garageTable.dataSource = self
		garageTable.delegate = self
        newCarPicker.dataSource = self
        newCarPicker.delegate = self
		_queryForCars()
        _queryForEpaCars()
    }
    
	@IBAction func pressedAddCar(sender: AnyObject) {
		_queryInsertCar()
	}
	
	// MARK: - PickerView Methods
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 3
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return years.count
        }
        if component == 1 {
            return makes.count
        }
		return models.count
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            _queryDeleteCar(cars[indexPath.row])
            self.updateCars(indexPath.row)

            if cars.count == 0 {
                tableView.reloadData()
                setEditing(false, animated: true)
            } else {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        }
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
    
    func _queryInsertCar(){
        var car = GTLGasstatsCar()
        car.userId = user_id
        car.carId = cars.count
        car.year = years.objectAtIndex(newCarPicker.selectedRowInComponent(0)) as NSNumber
        car.make = makes.objectAtIndex(newCarPicker.selectedRowInComponent(1)) as NSString
        car.model = models.objectAtIndex(newCarPicker.selectedRowInComponent(2)) as NSString
        let query = GTLQueryGasstats.queryForCarInsertWithObject(car) as GTLQueryGasstats
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        service.executeQuery(query, completionHandler: { (ticket, response, error) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if error != nil {
                self._showErrorDialog(error!)
                return
            }
            let returnedCar = response as GTLGasstatsCar
            car.entityKey = returnedCar.entityKey
            self.cars.append(car)
            self.garageTable.reloadData()
        })
    }
    
    func _queryForEpaCars(){
        let query = GTLQueryGasstats.queryForEpacarList() as GTLQueryGasstats
        query.limit = 99
        query.order = "year"
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        service.executeQuery(query, completionHandler: { (ticket, response, error) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.initialQueryComplete = true
            self._refreshControl?.endRefreshing()
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
            self.newCarPicker.reloadAllComponents()
        })
    }
    
    func _queryDeleteCar(carToDelete : GTLGasstatsCar) {
        //TODO Implement Delete
        /*
            We will need to do the following:
            -acquire the car's entity key
            -acquire the car's carId
            -delete the car via the query
            -if delete successful, we will need to query for all of that car/user combo's gasstats and delete them
            -Somehow we need to compensate for the manually generated car_ids
                -Problems: unless they delete the last car only, it will mess up the ids for adding a new car
                    -Possible solution 1: loop through and adjust the car_id's and their accompanying gasstats (will work but ineffecient)
                    -Possible solution 2: your guess is as good as mine :)
        */
        let query = GTLQueryGasstats.queryForCarDeleteWithEntityKey(carToDelete.entityKey) as GTLQueryGasstats
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        service.executeQuery(query) { (ticket, response, error) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if error != nil {
                self._showErrorDialog(error!)
                return
            }
            var deletedCarId = carToDelete.carId
            self._queryForDeleteGastats(carToDelete.carId.longLongValue, userId: carToDelete.userId.longLongValue)

        }
    }
    
    func _queryForUpdateGasstats(oldCarId : Int64, newCarId : NSNumber, userId : Int64) {
        let query = GTLQueryGasstats.queryForGasstatListByCarUser() as GTLQueryGasstats
        query.userId = userId
        query.carId = oldCarId
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
                    self.updateGasStats(stats, newID: newCarId)
                }
            }
        })
    }
    
    func _queryForDeleteGastats(carId : Int64, userId : Int64) {
        let query = GTLQueryGasstats.queryForGasstatListByCarUser() as GTLQueryGasstats
        query.userId = userId
        query.carId = carId
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
                    self.deleteGasStats(stats)
                }
            }
        })
    }
    
    func _queryDeleteGasStat(stat : GTLGasstatsGasStat) {
        let query = GTLQueryGasstats.queryForGasstatDeleteWithEntityKey(stat.entityKey) as GTLQueryGasstats
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        service.executeQuery(query) { (ticket, response, error) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if error != nil {
                self._showErrorDialog(error!)
                return
            }
        }
    }
    
    func _queryUpdateGasStat(stat : GTLGasstatsGasStat, newCarId : NSNumber) {
        stat.carId = newCarId
        let query = GTLQueryGasstats.queryForGasstatInsertWithObject(stat) as GTLQueryGasstats
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        service.executeQuery(query, completionHandler: { (ticket, response, error) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if error != nil {
                self._showErrorDialog(error!)
                return
            }
        })
    }
    
    func reloadMakeColumn() {
        makes = NSMutableArray()
        var selectedYearIndex = newCarPicker.selectedRowInComponent(0)
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
        var selectedYearIndex = newCarPicker.selectedRowInComponent(0)
        var selectedMakeIndex = newCarPicker.selectedRowInComponent(1)
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
    
    func deleteGasStats(stats : [GTLGasstatsGasStat]) {
        for stat in stats {
            _queryDeleteGasStat(stat)
        }
    }
    
    func updateGasStats(stats : [GTLGasstatsGasStat], newID : NSNumber) {
        for stat in stats {
            _queryUpdateGasStat(stat, newCarId: newID)
        }
    }
    
    func updateCars(index : Int) {
        var carToDelete = cars[index]
        var i = 0
        for i = 0; i < cars.count; i++ {
            if i > index {
                _queryForUpdateGasstats(cars[i].carId.longLongValue, newCarId: cars[i-1].carId, userId: carToDelete.userId.longLongValue)
            }
        }
        cars.removeAtIndex(index)
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
