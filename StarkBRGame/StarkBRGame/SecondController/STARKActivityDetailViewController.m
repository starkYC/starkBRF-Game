//
//  STARKActivityDetailViewController.m
//  StarkBRGame
//
//  Created by gaoyangchun on 14-1-15.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "STARKActivityDetailViewController.h"

@interface STARKActivityDetailViewController ()

@end

@implementation STARKActivityDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.navigationItem.title = @"活动详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.view.bounds = [[UIScreen mainScreen] bounds];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
