/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLQueryGasstats.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   gasstats/v1
// Description:
//   GasStats API
// Classes:
//   GTLQueryGasstats (25 custom class methods, 10 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLQuery.h"
#else
  #import "GTLQuery.h"
#endif

@class GTLGasstatsCar;
@class GTLGasstatsDriver;
@class GTLGasstatsEpaCar;
@class GTLGasstatsGasStat;
@class GTLGasstatsTankRecord;

@interface GTLQueryGasstats : GTLQuery

//
// Parameters valid on all methods.
//

// Selector specifying which fields to include in a partial response.
@property (copy) NSString *fields;

//
// Method-specific parameters; see the comments below for more information.
//
@property (assign) long long carId;
@property (copy) NSString *entityKey;
@property (assign) long long limit;
@property (copy) NSString *make;
@property (copy) NSString *model;
@property (copy) NSString *order;
@property (copy) NSString *pageToken;
@property (assign) long long userId;
@property (assign) long long year;

#pragma mark -
#pragma mark "car" methods
// These create a GTLQueryGasstats object.

// Method: gasstats.car.delete
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsCar.
+ (id)queryForCarDeleteWithEntityKey:(NSString *)entityKey;

// Method: gasstats.car.insert
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsCar.
+ (id)queryForCarInsertWithObject:(GTLGasstatsCar *)object;

// Method: gasstats.car.list
//  Optional:
//   limit: long long
//   order: NSString
//   pageToken: NSString
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsCarCollection.
+ (id)queryForCarList;

#pragma mark -
#pragma mark "car.list.by" methods
// These create a GTLQueryGasstats object.

// Method: gasstats.car.list.by.user
//  Optional:
//   userId: long long
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsCarCollection.
+ (id)queryForCarListByUser;

#pragma mark -
#pragma mark "driver" methods
// These create a GTLQueryGasstats object.

// Method: gasstats.driver.delete
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsDriver.
+ (id)queryForDriverDeleteWithEntityKey:(NSString *)entityKey;

// Method: gasstats.driver.insert
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsDriver.
+ (id)queryForDriverInsertWithObject:(GTLGasstatsDriver *)object;

// Method: gasstats.driver.list
//  Optional:
//   limit: long long
//   order: NSString
//   pageToken: NSString
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsDriverCollection.
+ (id)queryForDriverList;

#pragma mark -
#pragma mark "epacar" methods
// These create a GTLQueryGasstats object.

// Method: gasstats.epacar.delete
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsEpaCar.
+ (id)queryForEpacarDeleteWithEntityKey:(NSString *)entityKey;

// Method: gasstats.epacar.insert
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsEpaCar.
+ (id)queryForEpacarInsertWithObject:(GTLGasstatsEpaCar *)object;

// Method: gasstats.epacar.list
//  Optional:
//   limit: long long
//   order: NSString
//   pageToken: NSString
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsEpaCarCollection.
+ (id)queryForEpacarList;

#pragma mark -
#pragma mark "epacar.list.by" methods
// These create a GTLQueryGasstats object.

// Method: gasstats.epacar.list.by.year
//  Optional:
//   year: long long
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsEpaCarCollection.
+ (id)queryForEpacarListByYear;

#pragma mark -
#pragma mark "epacar.list.by.year" methods
// These create a GTLQueryGasstats object.

// Method: gasstats.epacar.list.by.year.make
//  Optional:
//   make: NSString
//   year: long long
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsEpaCarCollection.
+ (id)queryForEpacarListByYearMake;

#pragma mark -
#pragma mark "gasstat" methods
// These create a GTLQueryGasstats object.

// Method: gasstats.gasstat.delete
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsGasStat.
+ (id)queryForGasstatDeleteWithEntityKey:(NSString *)entityKey;

// Method: gasstats.gasstat.insert
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsGasStat.
+ (id)queryForGasstatInsertWithObject:(GTLGasstatsGasStat *)object;

// Method: gasstats.gasstat.list
//  Optional:
//   limit: long long
//   order: NSString
//   pageToken: NSString
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsGasStatCollection.
+ (id)queryForGasstatList;

#pragma mark -
#pragma mark "gasstat.list.by" methods
// These create a GTLQueryGasstats object.

// Method: gasstats.gasstat.list.by.car
//  Optional:
//   carId: long long
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsGasStatCollection.
+ (id)queryForGasstatListByCar;

#pragma mark -
#pragma mark "gasstat.list.by.car" methods
// These create a GTLQueryGasstats object.

// Method: gasstats.gasstat.list.by.car.user
//  Optional:
//   carId: long long
//   userId: long long
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsGasStatCollection.
+ (id)queryForGasstatListByCarUser;

#pragma mark -
#pragma mark "gasstat.list.by" methods
// These create a GTLQueryGasstats object.

// Method: gasstats.gasstat.list.by.user
//  Optional:
//   userId: long long
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsGasStatCollection.
+ (id)queryForGasstatListByUser;

#pragma mark -
#pragma mark "tankrecord" methods
// These create a GTLQueryGasstats object.

// Method: gasstats.tankrecord.delete
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsTankRecord.
+ (id)queryForTankrecordDeleteWithEntityKey:(NSString *)entityKey;

// Method: gasstats.tankrecord.insert
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsTankRecord.
+ (id)queryForTankrecordInsertWithObject:(GTLGasstatsTankRecord *)object;

// Method: gasstats.tankrecord.list
//  Optional:
//   limit: long long
//   order: NSString
//   pageToken: NSString
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsTankRecordCollection.
+ (id)queryForTankrecordList;

#pragma mark -
#pragma mark "tankrecord.list.by" methods
// These create a GTLQueryGasstats object.

// Method: gasstats.tankrecord.list.by.car
//  Optional:
//   carId: long long
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsTankRecordCollection.
+ (id)queryForTankrecordListByCar;

#pragma mark -
#pragma mark "tankrecord.list.by.car" methods
// These create a GTLQueryGasstats object.

// Method: gasstats.tankrecord.list.by.car.user
//  Optional:
//   carId: long long
//   userId: long long
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsTankRecordCollection.
+ (id)queryForTankrecordListByCarUser;

#pragma mark -
#pragma mark "tankrecord.list.by" methods
// These create a GTLQueryGasstats object.

// Method: gasstats.tankrecord.list.by.user
//  Optional:
//   userId: long long
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsTankRecordCollection.
+ (id)queryForTankrecordListByUser;

#pragma mark -
#pragma mark "tankrecord.list.by.year.make" methods
// These create a GTLQueryGasstats object.

// Method: gasstats.tankrecord.list.by.year.make.model
//  Optional:
//   make: NSString
//   model: NSString
//   year: long long
//  Authorization scope(s):
//   kGTLAuthScopeGasstatsUserinfoEmail
// Fetches a GTLGasstatsTankRecordCollection.
+ (id)queryForTankrecordListByYearMakeModel;

@end
