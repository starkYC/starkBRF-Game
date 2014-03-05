//
//  STARKSetterViewController.m
//  StarkBRGame
//
//  Created by gaoyangchun on 14-1-15.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "STARKSetterViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SetterCell.h"
#import "StarkPurchaseViewController.h"

@interface STARKSetterViewController ()
{
    NSMutableArray *_dataArray;
    NSMutableDictionary *_dict;
    
    NSMutableArray *_imagePathArray;
}
@end

@implementation STARKSetterViewController

#define TestFirID @"com.stark.test"
#define TestSECID @"com.stark.test2"
#define TestTHRID @"com.stark.test3"
#define TestFOURID @"com.test4"
#define TestFIVEID @"com.stark.test5"


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _imagePathArray  = [[NSMutableArray alloc] init];
    }
    return self;
}

-(float)fileSizeForDir:(NSString*)path//计算文件夹下文件的总大小
{
    [_imagePathArray removeAllObjects];

    NSFileManager *fileManager = [[NSFileManager alloc] init];
    float size =0;
    NSArray* array = [fileManager contentsOfDirectoryAtPath:path error:nil];
  
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
            size+= fileAttributeDic.fileSize/ 1024.0/1024.0;
            [_imagePathArray addObject:fullPath];
        }
        else
        {
            [self fileSizeForDir:fullPath];
        }
    }

    return size;
}
- (void)clearImageData:(UIButton*)clear{

    clear.enabled = NO;
    for(NSString *imagePath in _imagePathArray){
        
        NSError *error  = nil;
        if ([[NSFileManager defaultManager] removeItemAtPath:imagePath error:&error] ) {
            STRLOG(@"删除成功");
        }else{
            STRLOG(@"删除失败Error:%@",error);
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    NSArray *cacheArray  = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cache  = [cacheArray objectAtIndex:0];
    NSString *imageCache = [NSString stringWithFormat:@"%@/ImageCache",cache];
    
    UIButton *btn = (UIButton*)[self.view viewWithTag:100];
    btn.enabled = YES;
    
    float size = [self fileSizeForDir:imageCache];
    STRLOG(@"size:%lf",size);
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *delBtn= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [delBtn setFrame:CGRectMake(10, 300, 100, 30)];
    [delBtn setTitle:@"清图片缓存" forState:UIControlStateNormal];
    delBtn.tag = 100;
    [delBtn addTarget:self action:@selector(clearImageData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delBtn];
    //设置属性：不能滚动
    [self.tableView setScrollEnabled:NO];
    //self.tableView.layer.cornerRadius = 3.0;
    _dataArray = [[NSMutableArray alloc] initWithObjects:@"产品",@"产品2",@"产品3",@"产品4",@"产品5", nil];
    _dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:TestFirID,@"产品",TestSECID,@"产品2",TestTHRID,@"产品3",TestFOURID,@"产品4",TestFIVEID,@"产品5",nil];
    
    
}

#pragma mark 
#pragma mark   购买事件



#pragma mark tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StarkPurchaseViewController  *purchase = [[StarkPurchaseViewController alloc] init];
    NSString *proID = [_dict objectForKey:[_dataArray objectAtIndex:indexPath.row]];
    purchase.productID = proID;
    
    [self.navigationController pushViewController:purchase animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark tableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (SetterCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    
    SetterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SetterCell" owner:self options:0]lastObject];
    }
     [cell fillProductID:[_dataArray objectAtIndex:indexPath.row]];
   
   
    return cell;
}

-(void)startImageread:(NSIndexPath *)indexPath

{
    STRLOG(@"startImageread");
    UIImage *newimage ;// 从本地或者网络获取图片
 
    NSDictionary *cellimage = [NSDictionary dictionaryWithObjectsAndKeys:
                            
                               indexPath, @"indexPath",
                              
                               newimage,@"image",
                              
                               nil];
  
    [self performSelectorOnMainThread:@selector(_setOCellImage:) withObject:cellimage waitUntilDone:YES];
   
}



- (void)_setOCellImage:( id )celldata

{
    STRLOG(@"_setOCellImage");
    
    UIImage *newimage = [celldata objectForKey:@"image"];
   
    NSIndexPath *indexPath = [celldata objectForKey:@"indexPath"];

    [self.tableView cellForRowAtIndexPath:indexPath].imageView.image = newimage;
    
   // [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
