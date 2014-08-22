//
//  DetailController.h
//  FlatTest
//
//  Created by KroNIck on 20.08.14.
//  Copyright (c) 2014 KroNIck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostItem+Data.h"
#import "UserItem+Data.h"
#import "ImageItem+Data.h"

@interface DetailController : UICollectionViewController

@property (nonatomic, strong) PostItem *postItem;

@end
