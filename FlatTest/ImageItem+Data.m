//
//  ImageItem+Data.m
//  FlatTest
//
//  Created by KroNIck on 20.08.14.
//  Copyright (c) 2014 KroNIck. All rights reserved.
//

#import "ImageItem+Data.h"

@implementation ImageItem (Data)

+ (ImageItem *)addImageWithData:(NSDictionary *)data inContext:(NSManagedObjectContext *)context
{
    NSNumber *imageId = [data objectForKey:@"pid"];
    NSString *smallLInk = [data objectForKey:@"src_small"];
    NSNumber *dateNum = [data objectForKey:@"created"];
    
    ImageItem *image;
    
    if (imageId) {
        image = [ImageItem imageById:imageId inContext:context];
        
        if (!image) {
            image = [ImageItem MR_createInContext:context];
            image.imageId = imageId;
        }
        
        image.date = [NSDate dateWithTimeIntervalSince1970:dateNum.intValue];
        image.linkSmall = smallLInk;
    }
    
    return image;
}

+ (ImageItem *)imageById:(NSNumber *)imageId inContext:(NSManagedObjectContext *)context
{
    ImageItem *image;
    
    image = [ImageItem MR_findFirstByAttribute:@"imageId" withValue:imageId inContext:context];
    
    return image;
}

@end
