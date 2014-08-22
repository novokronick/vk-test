//
//  UserItem.h
//  FlatTest
//
//  Created by KroNIck on 20.08.14.
//  Copyright (c) 2014 KroNIck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PostItem;

@interface UserItem : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * photoLink;
@property (nonatomic, retain) NSSet *posts;
@end

@interface UserItem (CoreDataGeneratedAccessors)

- (void)addPostsObject:(PostItem *)value;
- (void)removePostsObject:(PostItem *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;

@end
