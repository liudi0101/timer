//
//  RecordTableViewController.m
//  Timer
//
//  Created by 刘帝 on 2018/5/19.
//  Copyright © 2018年 LD. All rights reserved.
//记录列表显式

#import "RecordTableViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "ViewController.h"


@interface RecordTableViewController ()
{
    AppDelegate *appDelegate;
    NSArray *resultArray;
}

@end

@implementation RecordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
}
-(void)viewWillAppear:(BOOL)animated{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Time" inManagedObjectContext:appDelegate.persistentContainer.viewContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:<#(nonnull NSString *), ...#>];
    //[request setPredicate:predicate];
    resultArray = [appDelegate.persistentContainer.viewContext executeFetchRequest:request error:nil];
    for (Time *time in resultArray) {
#ifdef DEBUG
        NSLog(@"%@ %@",time.date,time.time);
#endif
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return resultArray.count;
   
} 
//每行数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 为表格行定义一个静态字符串作为标识符
    static NSString* cellId = @"recordCell";
    // 从可重用表格行的队列中取出一个表格行
    UITableViewCell* cell = [tableView
                             dequeueReusableCellWithIdentifier:cellId];
    // 如果取出的表格行为nil
    if(cell == nil)
    {
        // 创建一个UITableViewCell对象，使用默认风格
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellId];
    }
    NSInteger rowNo = indexPath.row;
    UILabel *label1 =(UILabel*)[cell viewWithTag:1];
    Time *timeResult = resultArray[rowNo];
    label1.text = (NSString*)[NSString stringWithFormat:@"用时：%@",timeResult.time];
    UILabel *label2 = (UILabel*)[cell viewWithTag:2];
    //date转化成string类型
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *currentDateStr = [dateFormat stringFromDate:(NSDate*)timeResult.date];
    label2.text = [NSString stringWithFormat:@"记录日期：%@",currentDateStr];
    return cell;
}
#pragma mark - Table view Header

//tableview表头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

//tableview表头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor lightGrayColor];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 40.0);
    if (section == 0) {
        headerLabel.text =  @"记录";
    }
    /*else if (section == 1){
        headerLabel.text = @"测试2";
    }else if (section == 2){
        headerLabel.text = @"测试3";
    }else if (section == 3){
        headerLabel.text = @"测试4";
    }
    */
    [customView addSubview:headerLabel];
    return customView;
}
#pragma mark - Table view Detail
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 获取Storyboard文件中ID为detail的视图控制器
    DetailViewController* detailController = [self.storyboard
                                              instantiateViewControllerWithIdentifier:@"cellDetail"];
    // 保存用户正在编辑的表格行对应的NSIndexPath
    detailController.editingIndexPath = indexPath;
    Time *timeresult = resultArray[indexPath.row];
    detailController.time = (NSString*)timeresult.time;
    detailController.date = (NSDate*)timeresult.date;
    // 让应用程序的窗口显示detailViewController
    [self showViewController:detailController sender: self];
}
#pragma mark - Table view Delete Data
//左滑删除
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger rowNo = indexPath.row;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        ///读取所有时间的实体
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Time"
                                                  inManagedObjectContext:appDelegate.persistentContainer.viewContext];
        ///创建请求
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        [request setEntity:entity];
        Time *timeRequest = resultArray[rowNo];
        //按时间条件
        NSString *deleteTime = (NSString*)timeRequest.time;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"time=%@",deleteTime];
        [request setPredicate:predicate];
        ///获取符合条件的结果
        NSArray *deleteResultArray = [appDelegate.persistentContainer.viewContext executeFetchRequest:request
                                                                                          error:nil];
#ifdef DEBUG
        NSLog(@"%@",deleteResultArray);
#endif
        if (deleteResultArray.count>0) {
            for (Time *time in deleteResultArray) {
                ///删除实体
                [appDelegate.persistentContainer.viewContext deleteObject:time];
            }
            ///保存结果并且打印
            [appDelegate saveContext];
#ifdef DEBUG
            NSLog(@"删除完成");
#endif
        }
    }
    /*
     else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    */
    [self.tableView reloadData];
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
