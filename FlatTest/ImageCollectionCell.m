//
//  ImageCollectionCell.m
//  FlatTest
//
//  Created by KroNIck on 21.08.14.
//  Copyright (c) 2014 KroNIck. All rights reserved.
//

#import "ImageCollectionCell.h"
#import <UIImageView+WebCache.h>

@implementation ImageCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImageLink:(NSString *)imageLink
{
    _imageLink = imageLink;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageLink]];
}


@end
