//
//  ViewController.h
//  Timer
//
//  Created by 刘帝 on 2018/5/12.
//  Copyright © 2018年 LD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
- (IBAction)start:(id)sender;
- (IBAction)stop:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)resultBn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *speedLabel;
@property (strong, nonatomic) IBOutlet UILabel *resultTime;
@property (strong, nonatomic) IBOutlet UIButton *resultBn;
@end

