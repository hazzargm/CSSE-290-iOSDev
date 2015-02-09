/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLGasstatsCar.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   gasstats/v1
// Description:
//   GasStats API
// Classes:
//   GTLGasstatsCar (0 custom class methods, 9 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLObject.h"
#else
  #import "GTLObject.h"
#endif

// ----------------------------------------------------------------------------
//
//   GTLGasstatsCar
//

@interface GTLGasstatsCar : GTLObject
@property (retain) NSNumber *carId;  // longLongValue
@property (copy) NSString *createDateTime;
@property (copy) NSString *entityKey;
@property (copy) NSString *icon;  // GTLBase64 can encode/decode (probably web-safe format)
@property (copy) NSString *make;
@property (copy) NSString *model;
@property (retain) NSNumber *shared;  // boolValue
@property (retain) NSNumber *userId;  // longLongValue
@property (retain) NSNumber *year;  // longLongValue
@end
