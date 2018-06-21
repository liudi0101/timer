//
//  DetailViewController.h
//  Timer
//
//  Created by 刘帝 on 2018/6/14.
//  Copyright © 2018年 LD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
- (IBAction)returnBack:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) NSIndexPath *editingIndexPath;
@property (strong, nonatomic) NSString    *time;
@property (strong, nonatomic) NSDate      *date;
@end
