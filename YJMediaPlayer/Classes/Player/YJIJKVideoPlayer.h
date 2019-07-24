//
//  YJIJKVideoPlayer.h
//  IJK播放器Demo
//
//  Created by 刘亚军 on 2017/3/28.
//  Copyright © 2017年 lamiantv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YJIJKPlayerModel.h"
#import "YJIJKPlayerManager.h"

@class YJIJKVideoPlayer;

@protocol YJIJKVideoPlayerDelegate <NSObject>

@optional
/** 返回按钮被点击 */
- (void)playerBackButtonClick;
/** 播放器准备开始播放时 */
- (void)playerReadyToPlay;
/** 控制层封面点击事件的回调 */
- (void)controlViewTapAction;

/** 播放完了 */
- (void)playerDidEndAction;

/** 播放进度 */
- (void)changePlayProgress:(double)progress second:(CGFloat)second;

/** 视频状态改变时 */
- (void)changePlayerState:(YJIJKPlayerState)state;
@end

@interface YJIJKVideoPlayer : NSObject
/** 是否被用户暂停 */
@property (nonatomic, assign, readonly) BOOL isPauseByUser;

/**
 创建视频播放视图类
 @view   在正常屏幕下的视图位置
 @viewController 为当前播放视频的控制器
 */
+ (instancetype)videoPlayerWithView:(UIView *)view
                           delegate:(id<YJIJKVideoPlayerDelegate>)delegate
                        playerModel:(YJIJKPlayerModel *)playerModel;

- (void)setPlayerModelSrt:(YJIJKSrtModel *)srt;
- (void)setisMute:(BOOL)mute;
/**
 *  在当前页面，设置新的视频时候调用此方法
 */
- (void)resetToPlayNewVideo:(YJIJKPlayerModel *)playerModel; 


/** 自动播放，默认不自动播放 */
- (void)autoPlayTheVideo;

/** 播放视频 */
- (void)playVideo;
/** 暂停视频播放 */
- (void)pauseVideo;
/** 停止视频播放 */
- (void)stopVideo;

/** 销毁视频 */
- (void)destroyVideo;

- (void)seekToTime:(float)time;
@end
