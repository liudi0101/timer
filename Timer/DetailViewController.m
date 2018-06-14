//
//  DetailViewController.m
//  Timer
//
//  Created by 刘帝 on 2018/6/14.
//  Copyright © 2018年 LD. All rights reserved.
//列表显式详情页

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _timeLabel.text = self.time;
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *currentDateStr = [dateFormat stringFromDate:self.date];
    _dateLabel.text = currentDateStr;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)returnBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
