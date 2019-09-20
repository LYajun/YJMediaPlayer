//
//  YJIJKLandScapeControlView.h
//  拉面视频Demo
//
//  Created by 刘亚军 on 16/9/1.
//  Copyright © 2016年 lamiantv. All rights reserved.
//  横屏下的控制的view

#import <UIKit/UIKit.h>
@class YJIJKPlayerModel;
@protocol YJIJKLandScapeControlViewDelegate <NSObject>

/** 返回按钮被点击 */
- (void)landScapeBackButtonClick;
/** 播放暂停按钮被点击 */
- (void)landScapePlayPauseButtonClick:(BOOL)isSelected;

/** 进度条开始拖动 */
- (void)landScapeProgressSliderBeginDrag;
/** 进度结束拖动，并返回最后的值 */
- (void)landScapeProgressSliderEndDrag:(CGFloat)value;

/** 进度条tap点击 */
- (void)landScapeProgressSliderTapAction:(CGFloat)value;
/** 是否静音 */
- (void)landScapeMuteButtonClickWithIsMute:(BOOL)isMute;
@end

@interface YJIJKLandScapeControlView : UIView
@property (nonatomic, weak) id<YJIJKLandScapeControlViewDelegate> delegate;
@property (nonatomic,strong) YJIJKPlayerModel *playerModel;


/** 重置ControlView */
- (void)playerResetControlView;
- (void)playEndHideView:(BOOL)playeEnd;

// ---------------------------

/** 更新标题 */
- (void)syncTitle:(NSString *)title;

/** 更新播放/暂停按钮显示 */
- (void)syncplayPauseButton:(BOOL)isPlay;


/** 更新缓冲进度 */
- (void)syncbufferProgress:(double)progress;

/** 更新播放进度 */
- (void)syncplayProgress:(double)progress;

/** 更新当前播放时间 */
- (void)syncplayTime:(NSInteger)time;

/** 更新视频时长 */
- (void)syncDurationTime:(NSInteger)time;
@end
