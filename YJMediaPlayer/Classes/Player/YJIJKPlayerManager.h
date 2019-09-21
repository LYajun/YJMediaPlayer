//
//  YJIJKPlayerManager.h
//  IJK播放器Demo
//
//  Created by 刘亚军 on 2017/3/27.
//  Copyright © 2017年 lamiantv. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJIJKPlayerManager;
@class YJIJKPlayerStatusModel;

// 播放器的几种状态
typedef NS_ENUM(NSInteger, YJIJKPlayerState) {
    YJIJKPlayerStateUnknow,          // 未初始化的
    YJIJKPlayerStateFailed,          // 播放失败（无网络，视频地址错误）
    YJIJKPlayerStateReadyToPlay,     // 可以播放了
    YJIJKPlayerStateBuffering,       // 缓冲中
    YJIJKPlayerStatePlaying,         // 播放中
    YJIJKPlayerStatePause,           // 暂停播放
    YJIJKPlayerStateStoped           // 播放已停止（需要重新初始化）
};

@protocol YJIJKPlayerManagerDelegate <NSObject>


@required
/** 视频状态改变时 */
- (void)changePlayerState:(YJIJKPlayerState)state;
/** 播放进度改变时 @progress:范围：0 ~ 1 @second: 原秒数 */
- (void)changePlayProgress:(double)progress second:(CGFloat)second;
/** 缓冲进度改变时 @progress范围：0 ~ 1 @second: 原秒数 */
- (void)changeLoadProgress:(double)progress  second:(CGFloat)second ;
/** 当缓冲到可以再次播放时 */
- (void)didBuffer:(YJIJKPlayerManager *)playerMgr;
/** 播放器准备开始播放时 */
- (void)playerReadyToPlay;

/** 视频拖拽超过截止点 */
- (void)dragToSeekEndtime;
@end

@interface YJIJKPlayerManager : NSObject

/** playerLayerView */
@property (nonatomic, strong, readonly) UIView *playerLayerView;
+ (instancetype)playerManagerWithDelegate:(id<YJIJKPlayerManagerDelegate>)delegate playerStatusModel:(YJIJKPlayerStatusModel *)playerStatusModel;
- (void)initPlayerWithUrl:(NSURL *)url;

/** 获取视频时长，单位：秒 */
@property (nonatomic, assign, readonly) double duration;
/** 获取当前播放时间，单位：秒 */
@property (nonatomic, assign, readonly) double currentTime;
/** 获取当前状态 */
@property (nonatomic, assign, readonly) YJIJKPlayerState state;
- (void)updateSeekToEndTimePlayerState:(YJIJKPlayerState)state;
/** 从xx秒开始播放视频 */
@property (nonatomic, assign) NSTimeInterval seekTime;
/** 播放完成是否显示重播按钮 */
@property (nonatomic,assign) BOOL closeRepeatBtn;
/** 是否静音 */
@property (nonatomic, assign) BOOL isMute;

- (void)configMute:(BOOL)mute;
/**
 *  播放
 */
- (void)play;

/**
 *  重新播放
 */
- (void)rePlay;

/**
 *  暂停
 */
- (void)pause;

/**
 *  停止
 */
- (void)stop;

/**
 *  从xx秒开始播放视频跳转
 *
 *  @param dragedSeconds 视频跳转的秒数
 */
- (void)seekToTime:(CGFloat)dragedSeconds completionHandler:(void (^)())completionHandler;

/**
 *  改变音量
 */
- (void)changeVolume:(CGFloat)value;

@end
