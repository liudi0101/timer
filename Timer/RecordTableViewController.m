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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return resultArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger rowNo = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recordCell" forIndexPath:indexPath];
    UILabel *label1 =(UILabel*)[cell viewWithTag:1];
    Time *timeresult = resultArray[rowNo];
    label1.text = (NSString*)timeresult.time;
    UILabel *label2 = (UILabel*)[cell viewWithTag:2];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *currentDateStr = [dateFormat stringFromDate:(NSDate*)timeresult.date];
    label2.text = currentDateStr;
    // Configure the cell...
    return cell;
}
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
        headerLabel.text =  @"测试1";
    }else if (section == 1){
        headerLabel.text = @"测试2";
    }else if (section == 2){
        headerLabel.text = @"测试3";
    }else if (section == 3){
        headerLabel.text = @"测试4";
    }
    [customView addSubview:headerLabel];
    return customView;
}
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
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
