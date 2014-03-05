//
//  command.h
//  StarkBRGame
//
//  Created by gaoyangchun on 14-3-4.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#ifndef StarkBRGame_command_h
#define StarkBRGame_command_h


//输出调试信息
#define PRINT_DEBUG
#ifdef PRINT_DEBUG
#define STRLOG( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define STRLOG( s, ... )
#endif


#endif

