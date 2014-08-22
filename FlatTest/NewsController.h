//
//  NewsController.h
//  FlatTest
//
//  Created by KroNIck on 20.08.14.
//  Copyright (c) 2014 KroNIck. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

- (IBAction)accountButtonTap:(id)sender;

@end
