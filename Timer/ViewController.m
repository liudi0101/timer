//
//  ViewController.m
//  Timer
//
//  Created by 刘帝 on 2018/5/12.
//  Copyright © 2018年 LD. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "Time+CoreDataClass.h"
#import "Gauge.h"

const CGFloat endSpeed = 10; //测试极速值单位:(m/s)

@interface ViewController ()<CLLocationManagerDelegate>{
    AppDelegate *appDelegate;
}
@end

@implementation ViewController{
    NSTimer *timer; //计时器
    int currentTime; //时间计数
    CLLocationManager* _locationManager;
    CGFloat speed; //GPS当前速度
    Gauge *speedPanel ;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    speed = 0;
    //时间框初始显示
    self.timeLabel.text=@"00:00:00";
    //速度框初始显式
    self.speedLabel.text=@"0.0km/h";
    //初始化仪表盘
    speedPanel = [[Gauge alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen]bounds].size.height;
    speedPanel.center = CGPointMake(width/2, height/3);
    speedPanel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:speedPanel];
    //初始化定位GPS
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
#ifdef DEBUG
        NSLog(@"定位开启");
#endif
    }
    else
    {
#ifdef DEBUG
        NSLog(@"定位开启失败");
#endif
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 计时方法
//开始计时按钮
- (IBAction)start:(id)sender {
#ifdef DEBUG
        NSLog(@"开始等待起步");
#endif
        timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timeTick) userInfo:nil repeats:YES];
        //[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [self timeTick];
}

//计时器重置
- (IBAction)reset:(id)sender {
    self.timeLabel.text =@"00:00:00";
    self.speedLabel.text =@"0.0km/h";
    timer = nil;
    currentTime = 0;
#ifdef DEBUG
    NSLog(@"计时器重置成功");
#endif
}

//最下排按钮暂时没用
- (IBAction)resultBn:(id)sender {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Time" inManagedObjectContext:appDelegate.persistentContainer.viewContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:<#(nonnull NSString *), ...#>];
    //[request setPredicate:predicate];
    NSArray *resultArray = [appDelegate.persistentContainer.viewContext executeFetchRequest:request error:nil];
    for (Time *time in resultArray) {
        NSLog(@"%@ %@",time.date,time.time);
    }
}

//计时器停止
- (IBAction)stop:(id)sender {
    [timer invalidate];
    {Time *time = [NSEntityDescription insertNewObjectForEntityForName:@"Time" inManagedObjectContext:appDelegate.persistentContainer.viewContext];
    NSDate *currentDate = [NSDate date];
    time.date =currentDate;
    time.time = self.timeLabel.text;
#ifdef DEBUG
    NSLog(@"增加了一条记录日期%@时间%@",time.date,time.time);
#endif
    [appDelegate saveContext];
    }
#ifdef DEBUG
    NSLog(@"手动停止计时器计时");
#endif
}

//计时算法
-(void)timeTick{
#ifdef DEBUG
    NSLog(@"进入计时方法 当前速度%f",speed);
#endif
    if(speed>0&&speed<endSpeed){
        currentTime++;
        NSLog(@"%d",currentTime);
        [self upData];
    }
    else if (speed>=endSpeed){
        [timer invalidate];
        Time *time = [NSEntityDescription insertNewObjectForEntityForName:@"Time" inManagedObjectContext:appDelegate.persistentContainer.viewContext];
        NSDate *currentDate = [NSDate date];
        time.date = currentDate;
        time.time = self.timeLabel.text;
        self.resultTime.text = self.timeLabel.text;
#ifdef DEBUG
        NSLog(@"增加了一条记录日期%@时间%@",time.date,time.time);
        NSLog(@"自动停止计时器计时");
#endif
    }
}

//计时更新到界面
-(void)upData{
    int ms = abs(currentTime);
    int sec = currentTime/100;
    int min = sec/60;
    ms = ms - sec*100;
    sec = sec - min*60;
    //更新时间文本框
    self.timeLabel.text=[NSString stringWithFormat:@"%@%02d:%02d.%02d",(currentTime <0?@"-":@""),min,sec,ms] ;
}

#pragma mark - locationManager delegate
// 成功获取定位数据后方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation* location = locations.lastObject;
#ifdef DEBUG
    speed = 1;
    NSLog(@"gps数据更新");
#endif
    //获取当前速度
    speed = location.speed;
    //self.speedLabel.text = [NSString stringWithFormat:@"%.2fkm/h",speed*3.6];
    //更新仪表板指针
    [speedPanel setGaugeValue:speed*3.6 animation:YES];
    if (speed == -1) {
        self.speedLabel.text = @"0.0km/h";
    }
    else{
        //更新速度文本框
        self.speedLabel.text = [NSString stringWithFormat:@"%.2fkm/h",speed*3.6];
    }
    
}

// 定位失败时激发的方法
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
#ifdef DEBUG
    NSLog(@"定位失败: %@",error);
#endif
}
@end
