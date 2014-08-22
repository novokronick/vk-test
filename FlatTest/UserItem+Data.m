//
//  UserItem+Data.m
//  FlatTest
//
//  Created by KroNIck on 20.08.14.
//  Copyright (c) 2014 KroNIck. All rights reserved.
//

#import "UserItem+Data.h"

@implementation UserItem (Data)

+ (UserItem *)addGroupWithData:(NSDictionary *)data inContext:(NSManagedObjectContext *)context
{
    NSNumber *userId = (NSNumber *)[data objectForKey:@"gid"];
    NSString *name = [data objectForKey:@"name"];
    NSString *photoLink = [data objectForKey:@"photo"];
    
    UserItem *user;
    
    userId = [NSNumber numberWithInt:-userId.intValue]; // в постах у групп отрицательный идентификатор
    
    if (userId) {
        user = [UserItem userById:userId inContext:context];
        
        if (!user) {
            user = [UserItem MR_createInContext:context];
            user.userId = userId;
        }
        
        user.name = name;
        user.photoLink = photoLink;
    }
    
    return user;
}

+ (UserItem *)addUserWithData:(NSDictionary *)data inContext:(NSManagedObjectContext *)context
{
    NSNumber *userId = (NSNumber *)[data objectForKey:@"uid"];
    NSString *firstName = [data objectForKey:@"first_name"];
    NSString *lastName = [data objectForKey:@"last_name"];
    NSString *photoLink = [data objectForKey:@"photo_medium_rec"];
    
    UserItem *user;
    
    if (userId) {
        user = [UserItem userById:userId inContext:context];
        
        if (!user) {
            user = [UserItem MR_createInContext:context];
            user.userId = userId;
        }
        
        NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        user.name = fullName;
        
        user.photoLink = photoLink;
    }
    
    return user;
}

+ (UserItem *)userById:(NSNumber *)userId inContext:(NSManagedObjectContext *)context
{
    UserItem *user;
    
    user = [[UserItem MR_findByAttribute:@"userId" withValue:userId inContext:context] lastObject];
    
    return user;
}

@end
