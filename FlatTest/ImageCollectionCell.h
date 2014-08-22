//
//  ImageCollectionCell.h
//  FlatTest
//
//  Created by KroNIck on 21.08.14.
//  Copyright (c) 2014 KroNIck. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCollectionCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) NSString *imageLink;

@end
