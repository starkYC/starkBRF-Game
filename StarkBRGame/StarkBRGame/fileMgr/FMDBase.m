//
//  FMDBase.m
//  StarkBRGame
//
//  Created by gaoyangchun on 14-2-10.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "FMDBase.h"

static FMDBase * manger = nil;

@implementation FMDBase

+ (FMDBase*)shareDBManger{
   
    if (manger == nil) {
        manger = [[FMDBase alloc] init];
    }
    return manger;
}

+(id)copyWithZone:(NSZone *)zone{
    return self;
}

- (id)init{

    self = [super init ];
  
    if (self) {
        //应用程序沙盒(Documents)中，名为user.db的数据库路径
        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/user.db"];
        
        _dataBase = [[FMDatabase alloc] initWithPath:path];
        //_dataBase 的open方法，会根据路径创建user.db的数据库并打开，如果数据库已经存在，则直接打开.(Bool表示是否创建和打开成功)
        if ([_dataBase open]) {
            NSString *createTableSql =@"create table if not exists UserInfo(userID varchar(256) primary key ,userName varchar(256),userEmail varchar(256))";
            //executeUpdate（执行创建表、增、删、改 的sql语句）
            //BOOL 表示 sql语句是否执行成功
            BOOL isSuccessed = [_dataBase executeUpdate:createTableSql];
            if (!isSuccessed) {
                //lastErrorMessage拿到操作数据库最新的错误信息
                STRLOG(@"create error:%@",[_dataBase lastErrorMessage]);
            }
        }
    }
    return self;
}

- (void)insertDataWithModel:(AccoutInfo*)model{

    NSString *insertSql = @"insert into UserInfo(userID,userName,userEmail) values(?,?,?)";

    BOOL _isSuccessed = [_dataBase executeUpdate:insertSql,model.userID,model.userName,model.userEmail];
    if (!_isSuccessed) {
        STRLOG(@"insert error:%@",[_dataBase lastErrorMessage]);
    }else{
        STRLOG(@"添加成功");
    }
}

//更改对应id的数据
- (void)updateDataWithModel:(AccoutInfo*)model{

}

//删除对应id的数据
- (void)deleteDataWithModel:(AccoutInfo*)model{

    NSString *delSql = @"delete from UserInfo where userID = ?";
    BOOL _isSuccessed = [_dataBase executeUpdate:delSql,model.userID];
    if (!_isSuccessed) {
        STRLOG(@"delete error:%@",[_dataBase lastErrorMessage]);
    }else{
        STRLOG(@"删除成功");
    }
}

//获取数据
- (NSArray*)fetchAllUsers{
    
    NSString *sql = @"select * from UserInfo";
    //executeQuery 方法，用于执行查询操作的sql语句。
    //查询操作，所有的结果 放在 FMResultSet 实例中
    FMResultSet *rs= [_dataBase executeQuery:sql];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //next（从第一条数据开始取，Bool==YES 还存在下一条数据，不存在，则bool=NO，数据全部遍历完，循环终止）;
    //每次循环 读取一条数据
    while ([rs next]) {
        //拿到一条数据中字段的值
        NSString *userID = [rs stringForColumn:@"userID"];
        NSString *userName = [rs stringForColumn:@"userName"];
        NSString *userEmail = [rs stringForColumn:@"userEmail"];
        AccoutInfo *model = [[AccoutInfo alloc]init];
        model.userID = userID;
        model.userName = userName;
        model.userEmail = userEmail;
        [array addObject:model];
    }
    return array;

}
@end