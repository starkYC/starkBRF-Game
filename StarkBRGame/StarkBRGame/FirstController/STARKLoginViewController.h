//
//  STARKLoginViewController.h
//  StarkBRGame
//
//  Created by gaoyangchun on 14-1-16.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "RootViewController.h"
#import <FacebookSDK/FacebookSDK.h>


#import "STARKPersonalViewController.h"

@class GPPSignInButton;

@interface STARKLoginViewController : RootViewController
    <PersonDelegate>
@property (nonatomic,copy) NSString *userID;
@property (nonatomic,copy) NSString *type;

- (IBAction)fbbuttonClicked:(id)sender ;
@property (weak, nonatomic) IBOutlet GPPSignInButton *googleButton;
@property (weak, nonatomic) IBOutlet UIButton *fbButton;

@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;

@end
