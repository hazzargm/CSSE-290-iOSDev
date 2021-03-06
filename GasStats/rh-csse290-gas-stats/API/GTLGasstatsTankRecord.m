/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLGasstatsTankRecord.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   gasstats/v1
// Description:
//   GasStats API
// Classes:
//   GTLGasstatsTankRecord (0 custom class methods, 9 custom properties)

#import "GTLGasstatsTankRecord.h"

// ----------------------------------------------------------------------------
//
//   GTLGasstatsTankRecord
//

@implementation GTLGasstatsTankRecord
@dynamic avgTank, bestTank, carId, entityKey, lastTank, make, model, userId,
         year;

+ (NSDictionary *)propertyToJSONKeyMap {
  NSDictionary *map =
    [NSDictionary dictionaryWithObjectsAndKeys:
      @"avg_tank", @"avgTank",
      @"best_tank", @"bestTank",
      @"car_id", @"carId",
      @"last_tank", @"lastTank",
      @"user_id", @"userId",
      nil];
  return map;
}

@end
