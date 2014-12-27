//
//  ViewController.m
//  QingChunApp
//
//  Created by Peter Lee on 14/10/9.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "StartViewController.h"
#import "DisplayMessage.h"
@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
#ifdef TEST
    NSLog(peterLee);
#endif
    
    DisplayMessage *m1 = [[DisplayMessage alloc] init];
    m1.ID = 1234;
    m1.name = @"litianzhu";
    NSLog(@"%@",m1.description);
    
    DisplayMessage *m2 = [m1 copy];
    NSLog(@"%@",m2);
    
    [[NSUserDefaults standardUserDefaults] setObject:m2 forKey:@"123"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    DisplayMessage *m = [[NSUserDefaults standardUserDefaults] objectForKey:@"123"];
    
    NSLog(@"####%@",m.description);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
