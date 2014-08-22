//
//  LoginController.h
//  FlatTest
//
//  Created by KroNIck on 20.08.14.
//  Copyright (c) 2014 KroNIck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VKSdk.h>
#import "DataManager.h"

@interface LoginController : UIViewController <VKSdkDelegate>

@property (nonatomic, strong) IBOutlet UIButton *loginButton;

- (IBAction)loginTap:(id)sender;
- (IBAction)cancelTap:(id)sender;

@end
