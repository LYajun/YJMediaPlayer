//
//  YJIJKPlayerStatusModel.h
//  IJK播放器Demo
//
//  Created by 刘亚军 on 2017/3/30.
//  Copyright © 2017年 lamiantv. All rights reserved.
//  公有播放状态模型

#import <Foundation/Foundation.h>

@interface YJIJKPlayerStatusModel : NSObject
/** 是否自动播放 */
@property (nonatomic, assign, getter=isAutoPlay) BOOL autoPlay;
/** 是否被用户暂停 */
@property (nonatomic, assign, getter=isPauseByUser) BOOL pauseByUser;
/** 播放完了 */
@property (nonatomic, assign, getter=isPlayDidEnd) BOOL playDidEnd;
/** 播放失败 */
@property (nonatomic, assign) BOOL playFailure;
/** 进入后台 */
@property (nonatomic, assign, getter=isDidEnterBackground) BOOL didEnterBackground;
/** 是否正在拖拽进度条 */
@property (nonatomic, assign, getter=isDragged) BOOL dragged;

/** 是否全屏 */
@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;

/** 付费VIP模式 */
@property (nonatomic,assign) BOOL isVipMode;
/** 从xx秒开始播放视频 */
@property (nonatomic, assign) NSTimeInterval seekTime;
/** 从xx秒结束播放视频 */
@property (nonatomic, assign) NSTimeInterval seekEndTime;

/**
 重置状态模型属性
 */
- (void)playerResetStatusModel;

@end
