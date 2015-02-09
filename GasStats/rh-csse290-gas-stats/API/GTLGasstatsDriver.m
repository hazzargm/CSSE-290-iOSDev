/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLGasstatsDriver.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   gasstats/v1
// Description:
//   GasStats API
// Classes:
//   GTLGasstatsDriver (0 custom class methods, 6 custom properties)

#import "GTLGasstatsDriver.h"

// ----------------------------------------------------------------------------
//
//   GTLGasstatsDriver
//

@implementation GTLGasstatsDriver
@dynamic createDateTime, email, entityKey, password, userId, username;

+ (NSDictionary *)propertyToJSONKeyMap {
  NSDictionary *map =
    [NSDictionary dictionaryWithObjectsAndKeys:
      @"create_date_time", @"createDateTime",
      @"user_id", @"userId",
      nil];
  return map;
}

@end
