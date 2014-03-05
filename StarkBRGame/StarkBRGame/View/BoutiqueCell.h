//
//  BoutiqueCell.h
//  LimitFreeDemo
//
//  Created by gaoyangchun on 14-1-7.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoutiqueModel.h"

@interface BoutiqueCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *image;
@property (retain, nonatomic) IBOutlet UILabel *title;


- (void)fillData:(BoutiqueModel*)model;

@end
