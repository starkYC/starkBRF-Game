//
//  FMDBase.h
//  StarkBRGame
//
//  Created by gaoyangchun on 14-2-10.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "AccoutInfo.h"
@interface FMDBase : NSObject
{
    FMDatabase *_dataBase;
}

+ (FMDBase*)shareDBManger;

//添加model数据
- (void)insertDataWithModel:(AccoutInfo*)model;
//更改对应id的数据
- (void)updateDataWithModel:(AccoutInfo*)model;
//删除对应id的数据
- (void)deleteDataWithModel:(AccoutInfo*)model;
//获取数据
- (NSArray*)fetchAllUsers;

@end
