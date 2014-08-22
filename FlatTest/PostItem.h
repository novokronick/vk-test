//
//  PostItem.h
//  FlatTest
//
//  Created by KroNIck on 20.08.14.
//  Copyright (c) 2014 KroNIck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ImageItem, UserItem;

@interface PostItem : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * postId;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) UserItem *theUser;
@end

@interface PostItem (CoreDataGeneratedAccessors)

- (void)addImagesObject:(ImageItem *)value;
- (void)removeImagesObject:(ImageItem *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
