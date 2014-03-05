//
//  SetterCell.m
//  StarkBRGame
//
//  Created by gaoyangchun on 14-2-17.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "SetterCell.h"

@implementation SetterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillProductID:(NSString*)productID{
    
    self.Product.text = productID;
}
@end
