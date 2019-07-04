//
//  YJIJKVideoPlayerView.h
//  IJK播放器Demo
//
//  Created by 刘亚军 on 2017/3/28.
//  Copyright © 2017年 lamiantv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJIJKPlayerControlView.h"

@class YJIJKSrtModel;
@class YJIJKPlayerStatusModel;

@protocol YJIJKVideoPlayerViewDelagate <NSObject>
@optional
/** 双击事件 */
- (void)doubleTapAction;
/** pan开始水平移动 */
- (void)panHorizontalBeginMoved;
/** pan水平移动ing */
- (void)panHorizontaYJMoving:(CGFloat)value;
/** pan结束水平移动 */
- (void)panHorizontalEndMoved;
/** 音量改变 */
- (void)volumeValueChange:(CGFloat)value;

@end

@interface YJIJKVideoPlayerView : UIView
/** 视频控制层, 自定义层 */
@property (nonatomic, strong, readonly) YJIJKPlayerControlView *playerControlView;
/** 未播放, 封面的View */
@property (nonatomic, strong) YJIJKCoverControlView *coverControlView;
/** 未播放, loading时的View */
@property (nonatomic, strong) YJIJKLoadingView *loadingView;
/** 字幕 */
@property (nonatomic,strong) YJIJKSrtModel *srtModel;
/** 是否显示纯音乐背景 */
@property (nonatomic,assign) BOOL isShowVoiceBgImg;
/** 是否静音 */
@property (nonatomic, assign) BOOL isMute;
/** 获取视频时长，单位：秒 */
@property (nonatomic, assign) double duration;
/** 竖屏字幕不可见性，默认可见 */
@property (nonatomic,assign) BOOL portraitSrtInvisible;
/*
 *
 *
 */
+ (instancetype)videoPlayerViewWithSuperView:(UIView *)superview
                                    delegate:(id<YJIJKVideoPlayerViewDelagate>)delegate
                           playerStatusModel:(YJIJKPlayerStatusModel *)playerStatusModel;

/** 当前是否为全屏，默认为NO */
//@property (nonatomic, assign, getter=isFullScreen, readonly) BOOL fullScreen;

// 设置播放视图
- (void)setPlayerLayerView:(UIView *)playerLayerView;
/** 重置VideoPlayerView */
- (void)playerResetVideoPlayerView;
/**
 *  开始准备播放
 */
- (void)startReadyToPlay;
/**
 *  视频加载失败
 */
- (void)loadFailed;
/**
 *  设置横屏或竖屏
 */
- (void)shrinkOrFullScreen:(BOOL)isFull;
/**
 *  播放完了
 */
- (void)playDidEnd;
/**
 *  重新播放
 */
- (void)repeatPlay;
/** 当前播放进度 */
- (void)currentPlayProgress:(CGFloat)progress;
@end
