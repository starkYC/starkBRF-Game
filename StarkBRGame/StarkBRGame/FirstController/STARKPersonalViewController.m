//
//  STARKPersonalViewController.m
//  StarkBRGame
//
//  Created by gaoyangchun on 14-1-15.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "STARKPersonalViewController.h"


@interface STARKPersonalViewController ()

@end

@implementation STARKPersonalViewController

@synthesize name = _name;
@synthesize type = _type;
@synthesize userID = _userID;
#define Height 64
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"个人中心";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
    STRLOG(@"方式为:%@",self.type);
    STRLOG(@"个人ID:%@",self.userID);
    self.nameLabel.text = self.name;
//    [FBProfilePictureView class];
//    
//    FBProfilePictureView *ds = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(0, Height, 200, 150)];
//    ds.profileID = self.userID;
//    ds.pictureCropping  = 1;
//    [self.view addSubview:ds];
}

- (IBAction)signout:(id)sender{
    
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"Signout" object:nil];
    if ([self.delegate respondsToSelector:@selector(personSignout:)]) {
    
        [self.delegate personSignout:self.type];
    }else{
        
        STRLOG(@"代理方法没写");
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
