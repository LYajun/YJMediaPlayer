//
//  YJIJKPlayerControlView.h
//  lamiantv
//
//  Created by 刘亚军 on 2016/12/2.
//  Copyright © 2016年 AiPai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJIJKPortraitControlView.h"
#import "YJIJKLandScapeControlView.h"
#import "YJIJKCoverControlView.h"
#import "YJIJKLoadingView.h"
@class YJIJKPlayerStatusModel;

@protocol YJIJKPlayerControlViewDelagate <NSObject>
@optional
/** 加载失败按钮被点击 */
- (void)failButtonClick;
/** 重播按钮被点击 */
- (void)repeatButtonClick;
@end

@interface YJIJKPlayerControlView : UIView
+ (instancetype)playerControlViewWithStatusModel:(YJIJKPlayerStatusModel *)playerStatusModel;
@property (nonatomic, weak) id<YJIJKPlayerControlViewDelagate> delegate;
/** 是否显示了控制层 */
@property (nonatomic, assign, getter=isShowing, readonly) BOOL showing;

/** 竖屏控制层的View */
@property (nonatomic, strong) YJIJKPortraitControlView *portraitControlView;
/** 横屏控制层的View */
@property (nonatomic, strong) YJIJKLandScapeControlView *landScapeControlView;


/** 重置controlView */
- (void)playerResetControlView;
/** 开始准备播放 */
- (void)startReadyToPlay;

/** 显示状态栏 */
- (void)showStatusBar;
/** 显示控制层 */
- (void)showControl;
/** 隐藏控制层 */
- (void)hideControl;
/** 强行设置是否显示了控制层 */
- (void)setIsShowing:(BOOL)showing;
/** 取消延时隐藏controlView的方法 */
- (void)playerCancelAutoFadeOutControlView;
/** 延迟隐藏控制层 */
- (void)autoFadeOutControlView;


/** 显示快进视图 */
- (void)showFastView:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd;
/** 隐藏快进视图 */
- (void)hideFastView;


/** 准备开始播放, 隐藏loading */
- (void)readyToPlay;
/** 加载失败, 显示加载失败按钮 */
- (void)loadFailed;
/** 开始loading */
- (void)loading;
/** 播放完了, 显示重播按钮 */
- (void)playDidEnd;


/**
 *  播放完成时隐藏控制层
 */
- (void)playEndHideControlView;

/** 更新封面图片 */
- (void)syncCoverImageViewWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage;
@end
