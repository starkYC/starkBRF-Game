//
//  STARKAPPDetailViewController.h
//  StarkBRGame
//
//  Created by gaoyangchun on 14-1-15.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "RootViewController.h"
#import "BoutiqueModel.h"

@interface STARKAPPDetailViewController : RootViewController<UIScrollViewDelegate>

@property (nonatomic,assign) BoutiqueModel *model;
@property (nonatomic,copy) NSString *url;
@property (weak, nonatomic) IBOutlet UIImageView *appImage;
@property (weak, nonatomic) IBOutlet UILabel *appTitle;
@property (weak, nonatomic) IBOutlet UILabel *appPrice;
@property (weak, nonatomic) IBOutlet UITextView *summartText;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)downloadFromAPPStore:(id)sender;

@end
