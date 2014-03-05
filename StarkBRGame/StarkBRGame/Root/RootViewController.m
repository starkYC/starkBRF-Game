//
//  RootViewController.m
//  StarkBRGame
//
//  Created by gaoyangchun on 14-1-15.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "RootViewController.h"
#import "Reachability.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  Custom Method

#pragma mark  NSNotificationCenter
- (void)addMessage:(NSString*)messageName method:(SEL)method{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:method name:messageName object:nil];
}

- (void)removeMessage:(NSString *)messageName{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:messageName object:nil];
}@end
