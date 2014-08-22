//
//  UserItem+Data.h
//  FlatTest
//
//  Created by KroNIck on 20.08.14.
//  Copyright (c) 2014 KroNIck. All rights reserved.
//

#import "UserItem.h"
#import <CoreData+MagicalRecord.h>

@interface UserItem (Data)

+ (UserItem *)addGroupWithData:(NSDictionary *)data inContext:(NSManagedObjectContext *)context;
+ (UserItem *)userById:(NSNumber *)userId inContext:(NSManagedObjectContext *)context;
+ (UserItem *)addUserWithData:(NSDictionary *)data inContext:(NSManagedObjectContext *)context;

@end
