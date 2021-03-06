/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLServiceGasstats.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   gasstats/v1
// Description:
//   GasStats API
// Classes:
//   GTLServiceGasstats (0 custom class methods, 0 custom properties)

#import "GTLGasstats.h"

@implementation GTLServiceGasstats

#if DEBUG
// Method compiled in debug builds just to check that all the needed support
// classes are present at link time.
+ (NSArray *)checkClasses {
  NSArray *classes = [NSArray arrayWithObjects:
                      [GTLQueryGasstats class],
                      [GTLGasstatsCar class],
                      [GTLGasstatsCarCollection class],
                      [GTLGasstatsDriver class],
                      [GTLGasstatsDriverCollection class],
                      [GTLGasstatsEpaCar class],
                      [GTLGasstatsEpaCarCollection class],
                      [GTLGasstatsGasStat class],
                      [GTLGasstatsGasStatCollection class],
                      [GTLGasstatsTankRecord class],
                      [GTLGasstatsTankRecordCollection class],
                      nil];
  return classes;
}
#endif  // DEBUG

- (id)init {
  self = [super init];
  if (self) {
    // Version from discovery.
    self.apiVersion = @"v1";

    // From discovery.  Where to send JSON-RPC.
    // Turn off prettyPrint for this service to save bandwidth (especially on
    // mobile). The fetcher logging will pretty print.
    self.rpcURL = [NSURL URLWithString:@"https://rh-csse290-gas-stats.appspot.com/_ah/api/rpc?prettyPrint=false"];
  }
  return self;
}

@end
