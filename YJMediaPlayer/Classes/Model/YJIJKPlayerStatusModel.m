//
//  YJIJKPlayerStatusModel.m
//  IJK播放器Demo
//
//  Created by 刘亚军 on 2017/3/30.
//  Copyright © 2017年 lamiantv. All rights reserved.
//

#import "YJIJKPlayerStatusModel.h"

@implementation YJIJKPlayerStatusModel

/**
 重置状态模型属性
 */
- (void)playerResetStatusModel {
    self.autoPlay = NO;
    self.playDidEnd = NO;
    self.dragged = NO;
    self.didEnterBackground = NO;
    self.pauseByUser = YES;
    self.fullScreen = NO;
    
}
@end
