//
//  ImageItem+Data.h
//  FlatTest
//
//  Created by KroNIck on 20.08.14.
//  Copyright (c) 2014 KroNIck. All rights reserved.
//

#import "ImageItem.h"
#import <CoreData+MagicalRecord.h>

@interface ImageItem (Data)

+ (ImageItem *)imageById:(NSNumber *)imageId inContext:(NSManagedObjectContext *)context;
+ (ImageItem *)addImageWithData:(NSDictionary *)data inContext:(NSManagedObjectContext *)context;

@end
