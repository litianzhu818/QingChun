//
//  ViewController.m
//  QingChunApp
//
//  Created by Peter Lee on 14/10/9.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "StartViewController.h"
#import "TestObjectModel.h"
@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
#ifdef TEST
    NSLog(peterLee);
#endif
    
    TestObjectModel *m1 = [[TestObjectModel alloc] init];
    m1.ID = 1234;
    m1.name = @"litianzhu";
    NSLog(@"%@",m1.description);
    
    TestObjectModel *m2 = [m1 copy];
    NSLog(@"%@",m2);
    
    
    m2.name = @"刘艳芳";
    NSData *tempData1 = [NSKeyedArchiver archivedDataWithRootObject:m2];
    
    [[NSUserDefaults standardUserDefaults] setObject:tempData1 forKey:@"123"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSData *tempDate2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"123"];
    
    TestObjectModel *m = [NSKeyedUnarchiver unarchiveObjectWithData:tempDate2];
    
    NSLog(@"####%@",m.description);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
