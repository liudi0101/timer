//
//  ViewController.m
//  Timer
//
//  Created by 刘帝 on 2018/5/12.
//  Copyright © 2018年 LD. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
const CGFloat endSpeed = 10; //测试极速值；
@interface ViewController ()<CLLocationManagerDelegate>
@end

@implementation ViewController{
    NSTimer *timer;
    int currentTime; //时间计数
    CLLocationManager* _locationManager;
    CGFloat speed;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeLabel.text=@"00:00:00";
    self.speedLabel.text=@"0km/h";
    _locationManager = [[CLLocationManager alloc]init];
    if ([CLLocationManager locationServicesEnabled]) {
        if ([UIDevice currentDevice].systemVersion.floatValue >=9) {
            [_locationManager requestWhenInUseAuthorization];
            _locationManager.allowsBackgroundLocationUpdates =YES;
        }
        _locationManager.desiredAccuracy= kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.delegate = self;
        [_locationManager startUpdatingLocation];
        NSLog(@"定位开启");
    }
    else
    {
        NSLog(@"定位开启失败");
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//开始按钮处理方法
- (IBAction)start:(id)sender {
    while (YES) {
        NSLog(@"开始等待起步");
        if (speed>=0&&speed<endSpeed) {
            NSLog(@"计时开始");
            timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timeTick) userInfo:nil repeats:YES];
            [self timeTick];
        }
        break;
    }

}

//计时器重置
- (IBAction)reset:(id)sender {
    self.timeLabel.text =@"00:00:00";
    self.speedLabel.text =@"0km/h";
    timer = nil;
    currentTime = 0;
    NSLog(@"计时器重置成功");
}

//计时器停止
- (IBAction)stop:(id)sender {
    [timer invalidate];
    NSLog(@"手动停止计时器计时");
}

//计时算法
-(void)timeTick{
    if(speed<endSpeed){
        currentTime++;
        NSLog(@"%d",currentTime);
        [self upData];
    }
    else if (speed>=endSpeed){
        [timer invalidate];
        NSLog(@"自动停止计时器计时");
    }
}

//计时更新到界面
-(void)upData{
    int ms = abs(currentTime);
    int sec = currentTime/100;
    int min = sec/60;
    ms = ms - sec*100;
    sec = sec - min*60;
    self.timeLabel.text=[NSString stringWithFormat:@"%@%02d:%02d.%02d",(currentTime <0?@"-":@""),min,sec,ms] ;
    self.speedLabel.text = [NSString stringWithFormat:@"%02fkm/h",speed*3.6];
}

// 成功获取定位数据后方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation* location = locations.lastObject;
    speed = location.speed;
    NSLog(@"gps数据更新");
}

// 定位失败时激发的方法
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"定位失败: %@",error);
}
@end
