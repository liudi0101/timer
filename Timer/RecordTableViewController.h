//
//  RecordTableViewController.h
//  Timer
//
//  Created by 刘帝 on 2018/5/19.
//  Copyright © 2018年 LD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "Time+CoreDataClass.h"

@interface RecordTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;

@end
