//
//  TestViewController.h
//  QingChunApp
//
//  Created by Peter Lee on 14/10/24.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "BaseViewController.h"

@interface TestViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIButton *okButton;

-(IBAction)ClikedOnOkButton:(id)sender;

@end
