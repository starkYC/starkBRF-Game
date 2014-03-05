//
//  STARKPersonalViewController.h
//  StarkBRGame
//
//  Created by gaoyangchun on 14-1-15.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "RootViewController.h"
#import <FacebookSDK/FacebookSDK.h>
//个人中心界面

@protocol PersonDelegate <NSObject>

- (void)personSignout:(NSString *)type;

@end

@interface STARKPersonalViewController : RootViewController

@property (nonatomic,copy) NSString *userID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *type;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic,assign) id <PersonDelegate> delegate;

- (IBAction)signout:(id)sender ;
@end

