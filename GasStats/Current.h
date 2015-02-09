//
//  Current.h
//  GasStats
//
//  Created by CSSE Department on 2/8/15.
//  Copyright (c) 2015 Gordon Hazzard & Grant Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Current : NSManagedObject

@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSNumber * car_id;
@property (nonatomic, retain) NSNumber * loggedIn;

@end
