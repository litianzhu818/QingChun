//
//  BaseTableViewController.m
//  QingChunApp
//
//  Created by  李天柱 on 15/1/25.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _netWorkStatusNotice = [NotificationView sharedInstance];
    _netWorkStatusNotice.delegate = self;
    
    _defaultImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.view insertSubview:_defaultImageView atIndex:0];
    [_defaultImageView setUserInteractionEnabled:YES];
    
    //自动布局约束
    [_defaultImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSMutableArray *tmpConstraints = [NSMutableArray array];
    [tmpConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_defaultImageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_defaultImageView)]];
    [tmpConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_defaultImageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_defaultImageView)]];
    [self.view addConstraints:tmpConstraints];
    
    [_defaultImageView setImage:[UIImage imageNamed:@"background"]];
    
#if !__has_feature(objc_arc)
    
#endif
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

/*********************************Private方法********************************************/

/**
 *  断网
 */
-(void)disconnectWithNet
{
    //提示断网
    [self performSelector:@selector(showNetworkSratusNotification) withObject:nil afterDelay:0.1];
}
/**
 *  再次连接网络
 */
-(void)connectWithNetAgain
{
    //重新连接代码
    [_netWorkStatusNotice dissmissNotificationView];
    [StatusBar dismiss];
}

-(void)showNetworkSratusNotification
{
    [_netWorkStatusNotice showViewWithText:@"notice" detail:@"There is no internet connection" image:PNG_NAME(@"no_internet.png")];
}

#pragma mark MPNotificationViewDelegate Methods
- (void)deleteNotificationView
{
    if ([[NetStatusManager sharedInstance] getNowNetWorkStatus] == NotReachable) {
        [StatusBar showWithStatus:@"no internet…"];
    }
}

- (void)dealloc
{
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
    
}

/**
 *  弹出提示对话框
 *
 *  @param message 对话框显示的类容
 */
-(void)showMessage:(NSString *)message
             title:(NSString *)title
 cancelButtonTitle:(NSString *)cancelTitle
       cancleBlock:(void (^)(void))cancleBlock
  otherButtonTitle:(NSString *)otherButtonTitle
        otherBlock:(void (^)(void))otherBlock
{
    UICustomAlertView *alertView = [[UICustomAlertView alloc] initWithTitle:title
                                                                    message:message
                                                          cancelButtonTitle:cancelTitle
                                                                cancleBlock:cancleBlock
                                                           otherButtonTitle:otherButtonTitle
                                                                 otherBlock:otherBlock];
    [alertView show];
}

-(void)showMessage:(NSString *)message
             title:(NSString *)title
 cancelButtonTitle:(NSString *)cancelTitle
       cancleBlock:(void (^)(void))cancleBlock
{
    UICustomAlertView *alertView = [[UICustomAlertView alloc] initWithTitle:title
                                                                    message:message
                                                          cancelButtonTitle:cancelTitle
                                                                cancleBlock:cancleBlock];
    [alertView show];
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}
*/
/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
 */

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
