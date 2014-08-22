//
//  ImageItem.h
//  FlatTest
//
//  Created by KroNIck on 21.08.14.
//  Copyright (c) 2014 KroNIck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PostItem;

@interface ImageItem : NSManagedObject

@property (nonatomic, retain) NSString * linkSmall;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * imageId;
@property (nonatomic, retain) PostItem *thePost;

@end
