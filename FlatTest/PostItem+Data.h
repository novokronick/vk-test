//
//  PostItem+Data.h
//  FlatTest
//
//  Created by KroNIck on 20.08.14.
//  Copyright (c) 2014 KroNIck. All rights reserved.
//

#import "PostItem.h"
#import <CoreData+MagicalRecord.h>

@interface PostItem (Data)

+ (PostItem *)postById:(NSNumber *)postId inContext:(NSManagedObjectContext *)context;
+ (PostItem *)addPostWithData:(NSDictionary *)data inContext:(NSManagedObjectContext *)context;
- (NSArray *)sortedImagesArray;

@end
