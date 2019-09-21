//
//  YJIJKVideoPlayer.m
//  IJK播放器Demo
//
//  Created by 刘亚军 on 2017/3/28.
//  Copyright © 2017年 lamiantv. All rights reserved.
//

#import "YJIJKVideoPlayer.h"
#import "YJIJKVideoPlayerView.h"
#import "YJIJKPlayerStatusModel.h"
#import "YJIJKBrightnessView.h"

@interface YJIJKVideoPlayer ()<YJIJKPlayerManagerDelegate, YJIJKPlayerControlViewDelagate, YJIJKPortraitControlViewDelegate, YJIJKLandScapeControlViewDelegate, YJIJKVideoPlayerViewDelagate, YJIJKLoadingViewDelegate, YJIJKCoverControlViewDelegate>

// 代理
@property (nonatomic, weak) id<YJIJKVideoPlayerDelegate> delegate;
// 最底层的父视图
@property (nonatomic, strong) YJIJKVideoPlayerView *videoPlayerView;
// AVPlayer 管理
@property (nonatomic, strong) YJIJKPlayerManager *playerMgr;
// 播放数据模型
@property (nonatomic, strong) YJIJKPlayerModel *playerModel;
/** 播放器的参数模型 */
@property (nonatomic, strong) YJIJKPlayerStatusModel *playerStatusModel;


/** 用来保存pan手势快进的总时长 */
@property (nonatomic, assign) CGFloat sumTime;
/** 是否被用户暂停 */
@property (nonatomic, assign) BOOL isPauseByUser;

@property (nonatomic, assign) BOOL isSeekToStartTime;
@property (nonatomic, assign) BOOL isSeekToEndTime;
@end

@implementation YJIJKVideoPlayer
#pragma mark - getter

//- (UIView *)portraitControlView {
//    return self.videoPlayerView.portraitControlView;
//}
//
//- (UIView *)landScapeControlView {
//    return self.videoPlayerView.landScapeControlView;
//}

#pragma mark - public method

+ (instancetype)videoPlayerWithView:(UIView *)view delegate:(id<YJIJKVideoPlayerDelegate>)delegate playerModel:(YJIJKPlayerModel *)playerModel {
    
    if (view == nil) {
        return nil;
    }
    
    YJIJKVideoPlayer *instance = [[YJIJKVideoPlayer alloc] init];
    instance.delegate = delegate;
    
    // 创建状态模型
    instance.playerStatusModel = [[YJIJKPlayerStatusModel alloc] init];
    [instance.playerStatusModel playerResetStatusModel];
    
    instance.playerStatusModel.isVipMode = playerModel.isVipMode;
    instance.playerStatusModel.seekTime = playerModel.seekTime;
    instance.playerStatusModel.seekEndTime = playerModel.seekEndTime;
    
    // !!!: 最底层视图创建
    instance.videoPlayerView = [YJIJKVideoPlayerView videoPlayerViewWithSuperView:view delegate:instance playerStatusModel:instance.playerStatusModel];
    instance.videoPlayerView.srtModel = playerModel.srtModel;
    instance.videoPlayerView.isMute = playerModel.isMute;
    instance.videoPlayerView.isShowVoiceBgImg = playerModel.isShowVoiceBgImg;
    instance.videoPlayerView.portraitSrtInvisible = playerModel.portraitSrtInvisible;
    instance.videoPlayerView.playerControlView.delegate = instance;
    instance.videoPlayerView.playerControlView.portraitControlView.delegate
    = instance;
    instance.videoPlayerView.playerControlView.portraitControlView.playerModel = playerModel;
    instance.videoPlayerView.playerControlView.landScapeControlView.delegate
    = instance;
    instance.videoPlayerView.playerControlView.landScapeControlView.playerModel = playerModel;
    instance.videoPlayerView.coverControlView.delegate
    = instance;
    instance.videoPlayerView.loadingView.delegate
    = instance;
    
    
    // !!!: 创建AVPlayer管理
    instance.playerMgr = [YJIJKPlayerManager playerManagerWithDelegate:instance playerStatusModel:instance.playerStatusModel];
    instance.playerMgr.isMute = playerModel.isMute;
    instance.playerMgr.seekTime = playerModel.seekTime;
    instance.playerMgr.closeRepeatBtn = playerModel.closeRepeatBtn;
    instance.isPauseByUser = YES;
    
    // 设置基本模型 (最后设置)
    instance.playerModel = playerModel;
    
    return instance;
}
- (void)setPlayerModelSrt:(YJIJKSrtModel *)srt{
    self.playerModel.srtModel = srt;
    self.videoPlayerView.srtModel = srt;
}
- (void)setisMute:(BOOL)mute{
    self.playerModel.isMute = mute;
    self.videoPlayerView.isMute = mute;
    [self.playerMgr configMute:mute];
}
// !!!: 销毁视频
- (void)destroyVideo {
    [self.playerMgr stop];
    [self.videoPlayerView removeFromSuperview];
    
    self.playerMgr = nil;
    self.videoPlayerView = nil;
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)setPlayerModel:(YJIJKPlayerModel *)playerModel {
    _playerModel = playerModel;
    
    // 同步一些属性
    [self.videoPlayerView.coverControlView syncCoverImageViewWithURLString:playerModel.placeholderImageURLString placeholderImage:playerModel.placeholderImage];
    [self.videoPlayerView.playerControlView syncCoverImageViewWithURLString:playerModel.placeholderImageURLString placeholderImage:playerModel.placeholderImage];
    [self.videoPlayerView.playerControlView.landScapeControlView syncTitle:self.playerModel.title];
    
    
}

/** 自动播放，默认不自动播放 */
- (void)autoPlayTheVideo {
    [self configYJIJKPlayer];
    [self.videoPlayerView.coverControlView removeFromSuperview];
    self.videoPlayerView.loadingView.hidden = NO;
    
}

// 设置Player相关参数
- (void)configYJIJKPlayer {
    
    // 销毁之前的视频
    if(self.playerMgr) {
        [self.playerMgr stop];
    }
    [self.videoPlayerView.playerControlView loading];
   
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [weakSelf.playerMgr initPlayerWithUrl:weakSelf.playerModel.videoURL];
        [weakSelf.videoPlayerView setPlayerLayerView:weakSelf.playerMgr.playerLayerView];
        weakSelf.isPauseByUser = NO;
        
    });
}

/**
 *  重置player
 */
- (void)resetPlayer
{
    // 改为为播放完
    self.playerStatusModel.playDidEnd         = NO;
    self.playerStatusModel.didEnterBackground = NO;
    self.playerStatusModel.autoPlay           = NO;
    
    if (self.playerMgr) {
        [self.playerMgr stop];
    }
    
    [self.videoPlayerView playerResetVideoPlayerView];
    
   
}

/**
 *  在当前页面，设置新的视频时候调用此方法
 */
- (void)resetToPlayNewVideo:(YJIJKPlayerModel *)playerModel {
    [self resetPlayer];
    self.playerModel = playerModel;
    [self configYJIJKPlayer];
}

- (void)playVideo {
    // 如果已经播放完的情况下点击就重新开始播放， 因状态已经为stoped了
    if (self.playerMgr.state == YJIJKPlayerStateStoped) {
        [self.playerMgr rePlay]; //
    } else {
        [self.playerMgr play];
    }
}

- (void)pauseVideo {
    [self.playerMgr pause];
}

- (void)stopVideo {
    [self.playerMgr stop];
}
- (void)seekToTime:(float)time{
    if ((self.playerMgr.state >= 2 && self.playerMgr.state <= 5) || (self.playerMgr.state >= 2 && self.playerModel.closeRepeatBtn)) {
        __weak typeof(self) wself = self;
        [self.playerMgr seekToTime:time completionHandler:^(){
            wself.playerStatusModel.dragged = NO;
            [wself.playerMgr play];
            // 延迟隐藏控制层
            [wself.videoPlayerView.playerControlView autoFadeOutControlView];
        }];
    }
}
#pragma mark - YJIJKAVPlayerManagerDelegate

- (void)changePlayerState:(YJIJKPlayerState)state {
    if (self.delegate && [self.delegate respondsToSelector:@selector(changePlayerState:)]) {
        [self.delegate changePlayerState:state];
    }
    self.playerStatusModel.playFailure = NO;
    switch (state) {
        case YJIJKPlayerStateReadyToPlay:{
            
            [self.videoPlayerView.playerControlView readyToPlay];
        }
            break;
        case YJIJKPlayerStatePlaying: {
            [self.videoPlayerView.playerControlView.portraitControlView syncplayPauseButton:YES];
            [self.videoPlayerView.playerControlView.landScapeControlView syncplayPauseButton:YES];
            self.isPauseByUser = NO;
        }
            break;
        case YJIJKPlayerStatePause: {
            [self.videoPlayerView.playerControlView.portraitControlView syncplayPauseButton:NO];
            [self.videoPlayerView.playerControlView.landScapeControlView syncplayPauseButton:NO];
            self.isPauseByUser = YES;
        }
            break;
        case YJIJKPlayerStateStoped: {
            if (!self.playerModel.closeRepeatBtn) {
                [self.videoPlayerView playDidEnd];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(playerDidEndAction)]) {
                [self.delegate playerDidEndAction];
            }
        }
            break;
        case YJIJKPlayerStateBuffering: {
            [self.videoPlayerView.playerControlView loading];
        }
            break;
        case YJIJKPlayerStateFailed: {
            self.playerStatusModel.playFailure = YES;
            if (self.playerStatusModel.isFullScreen) {
                [self landScapeBackButtonClick];
            }
            [self.videoPlayerView loadFailed];
            self.videoPlayerView.loadingView.hidden = YES;
            
            YJIJKBrightnessViewShared.isStartPlay = YES;
            [self.videoPlayerView.playerControlView loadFailed];
        }
            break;
        default:
            break;
    }
}
- (void)dragToSeekEndtime{
    [self pauseVideo];
    [self changePlayerState:YJIJKPlayerStateStoped];
    self.isSeekToEndTime = YES;
    self.playerStatusModel.playDidEnd = YES;
}
- (void)changeLoadProgress:(double)progress second:(CGFloat)second {
    [self.videoPlayerView.playerControlView.landScapeControlView syncbufferProgress:progress];
    [self.videoPlayerView.playerControlView.portraitControlView syncbufferProgress:progress];
    
    // 如果缓冲达到俩秒以上或者缓冲完成则播放，先检测当前视频状态是否为播放
    if (progress == 1.0f ||  second >= [self.playerMgr currentTime] + 2.5) { // 当前播放位置秒数 + 2.5 小于等于 缓冲到的位置秒数
        [self didBuffer:self.playerMgr];
    }
}

- (void)changePlayProgress:(double)progress second:(CGFloat)second {
    if (self.playerStatusModel.isDragged) { // 在拖拽进度条的时候不应去更新进度条的值
        return;
    }
    
    if (!self.isSeekToStartTime && self.playerModel.seekTime > 0 && second > 0 && second < self.playerModel.seekTime) {
        [self seekToTime:self.playerModel.seekTime];
        self.isSeekToStartTime = YES;
        return;
    }
    
    
    if (!self.isSeekToEndTime && self.playerModel.seekEndTime > 0 && second > self.playerModel.seekEndTime) {
        [self dragToSeekEndtime];
        return;
    }
    
    if (second > self.playerModel.seekTime) {
        self.isSeekToStartTime = NO;
    }
    
    self.videoPlayerView.duration = self.playerMgr.duration;
    [self.videoPlayerView currentPlayProgress:progress];
    [self.videoPlayerView.playerControlView.portraitControlView syncplayProgress:progress];
    [self.videoPlayerView.playerControlView.landScapeControlView syncplayProgress:progress];
    [self.videoPlayerView.playerControlView.portraitControlView syncplayTime:second];
    [self.videoPlayerView.playerControlView.landScapeControlView syncplayTime:second];
    [self.videoPlayerView.playerControlView.portraitControlView syncDurationTime:self.playerMgr.duration];
    [self.videoPlayerView.playerControlView.landScapeControlView syncDurationTime:self.playerMgr.duration];
    
    if (!self.playerStatusModel.isPlayDidEnd) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(changePlayProgress:second:)]) {
            [self.delegate changePlayProgress:progress second:second];
        }
    }
}

- (void)didBuffer:(YJIJKPlayerManager *)playerMgr { 
    if (self.playerMgr.state == YJIJKPlayerStateBuffering || !self.playerStatusModel.isPauseByUser) {
        [self.playerMgr play];
//        [self.videoPlayerView.playerControlView readyToPlay];
    }
}

/** 播放器准备开始播放时 */
- (void)playerReadyToPlay {
    [self.videoPlayerView startReadyToPlay];
    self.videoPlayerView.loadingView.hidden = YES;
    
    YJIJKBrightnessViewShared.isStartPlay = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerReadyToPlay)]) {
        [self.delegate playerReadyToPlay];
    }
}

#pragma mark - YJIJKPlayerControlViewDelagate
/** 加载失败按钮被点击 */
- (void)failButtonClick {
    [self configYJIJKPlayer];
}

/** 重播按钮被点击 */
- (void)repeatButtonClick {
    if (self.isSeekToEndTime) {
        [self.playerMgr updateSeekToEndTimePlayerState:YJIJKPlayerStatePause];
        [self seekToTime:0];
    }else{
        [self.playerMgr rePlay];
    }
    self.isSeekToStartTime = NO;
    self.isSeekToEndTime = NO;
    
    [self.videoPlayerView repeatPlay];
    
    // 没有播放完
    self.playerStatusModel.playDidEnd = NO;
    //    if ([self.videoURL.scheme isEqualToString:@"file"]) {
    //        self.state = YJIJKPlayerStatePlaying;
    //    } else {
    //        self.state = YJIJKPlayerStateBuffering;
    //    }
}

#pragma mark - YJIJKPortraitControlViewDelegate
/** 返回按钮被点击 */
- (void)portraitBackButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerBackButtonClick)]) {
        [self.delegate playerBackButtonClick];
    }
}

/** 播放暂停按钮被点击, 是否选中，选中时当前为播发，按钮为暂停的 */
- (void)portraitPlayPauseButtonClick:(BOOL)isSelected {
    // 延迟隐藏控制层
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    
    if (isSelected) {
        [self.playerMgr pause];
    } else {
        // 如果已经播放完的情况下点击就重新开始播放， 因状态已经为stoped了
        if (self.playerMgr.state == YJIJKPlayerStateStoped) {
            [self.playerMgr rePlay]; //
        } else {
            [self.playerMgr play];
        }
    }
}

/** 进度条开始拖动 */
- (void)portraitProgressSliderBeginDrag {
    self.playerStatusModel.dragged = YES;
    [self.videoPlayerView.playerControlView playerCancelAutoFadeOutControlView];
}

/** 进度结束拖动，并返回最后的值 */
- (void)portraitProgressSliderEndDrag:(CGFloat)value {
    //计算出拖动的当前秒数
    __weak typeof(self) wself = self;
    NSInteger dragedSeconds = floorf(self.playerMgr.duration * value);
    [self.playerMgr seekToTime:dragedSeconds completionHandler:^(){
        wself.playerStatusModel.dragged = NO;
        [wself.playerMgr play];
        // 延迟隐藏控制层
        [self.videoPlayerView.playerControlView autoFadeOutControlView];
    }];
}

/** 全屏按钮被点击 */
- (void)portraitFullScreenButtonClick {
    // 延迟隐藏控制层
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    
    [self.videoPlayerView shrinkOrFullScreen:YES];
}

/** 进度条tap点击 */
- (void)portraitProgressSliderTapAction:(CGFloat)value {
    //计算出拖动的当前秒数
    __weak typeof(self) wself = self;
    NSInteger dragedSeconds = floorf(self.playerMgr.duration * value);
    [self.playerMgr seekToTime:dragedSeconds completionHandler:^(){
        wself.playerStatusModel.dragged = NO;
        [wself.playerMgr play];
        
        // 延迟隐藏控制层
        [wself.videoPlayerView.playerControlView autoFadeOutControlView];
    }];
}
- (void)portraitMuteButtonClickWithIsMute:(BOOL)isMute{
    [self setisMute:isMute];
}
#pragma mark - YJIJKLandScapeControlViewDelegate
/** 返回按钮被点击 */
- (void)landScapeBackButtonClick {
    // 延迟隐藏控制层
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    
    [self.videoPlayerView shrinkOrFullScreen:NO];
}

/** 播放暂停按钮被点击 */
- (void)landScapePlayPauseButtonClick:(BOOL)isSelected {
    // 延迟隐藏控制层
    [self.videoPlayerView.playerControlView autoFadeOutControlView];
    
    if (isSelected) {
        [self.playerMgr pause];
    } else {
        // 如果已经播放完的情况下点击就重新开始播放， 因状态已经为stoped了
        if (self.playerMgr.state == YJIJKPlayerStateStoped) {
            [self.playerMgr rePlay]; //
        } else {
            [self.playerMgr play];
        }
    }
}

/** 进度条开始拖动 */
- (void)landScapeProgressSliderBeginDrag {
    self.playerStatusModel.dragged = YES;
    
    [self.videoPlayerView.playerControlView playerCancelAutoFadeOutControlView];
}

/** 进度结束拖动，并返回最后的值 */
- (void)landScapeProgressSliderEndDrag:(CGFloat)value {
    //计算出拖动的当前秒数
    __weak typeof(self) wself = self;
    NSInteger dragedSeconds = floorf(self.playerMgr.duration * value);
    [self.playerMgr seekToTime:dragedSeconds completionHandler:^(){
        wself.playerStatusModel.dragged = NO;
        [wself.playerMgr play];
        
        // 延迟隐藏控制层
        [self.videoPlayerView.playerControlView autoFadeOutControlView];
    }];
}

/** 进度条tap点击 */
- (void)landScapeProgressSliderTapAction:(CGFloat)value {
    //计算出拖动的当前秒数
    __weak typeof(self) wself = self;
    NSInteger dragedSeconds = floorf(self.playerMgr.duration * value);
    [self.playerMgr seekToTime:dragedSeconds completionHandler:^(){
        wself.playerStatusModel.dragged = NO;
        [wself.playerMgr play];
        
        // 延迟隐藏控制层
        [wself.videoPlayerView.playerControlView autoFadeOutControlView];
    }];
}
- (void)landScapeMuteButtonClickWithIsMute:(BOOL)isMute{
    [self setisMute:isMute];
}
#pragma mark - YJIJKVideoPlayerViewDelagate
/** 双击事件 */
- (void)doubleTapAction {
    if (self.playerStatusModel.isPauseByUser) {
        [self.playerMgr play];
    } else {
        [self.playerMgr pause];
    }
    if (!self.playerStatusModel.isAutoPlay) {
        self.playerStatusModel.autoPlay = YES;
        [self configYJIJKPlayer];
    }
}

/** pan开始水平移动 */
- (void)panHorizontalBeginMoved {
    // 给sumTime初值
    self.sumTime = self.playerMgr.currentTime;
}

/** pan水平移动ing */
- (void)panHorizontaYJMoving:(CGFloat)value {
    // 每次滑动需要叠加时间
    self.sumTime += value / 200;
    
    // 需要限定sumTime的范围
    CGFloat totaYJMovieDuration = self.playerMgr.duration;
    if (self.sumTime > totaYJMovieDuration) { self.sumTime = totaYJMovieDuration;}
    if (self.sumTime < 0) { self.sumTime = 0; }
    
    BOOL style = false;
    if (value > 0) { style = YES; }
    if (value < 0) { style = NO; }
    if (value == 0) { return; }
    
    self.playerStatusModel.dragged = YES;
    
    // 改变currentLabel值
    CGFloat draggedValue = (CGFloat)self.sumTime/(CGFloat)totaYJMovieDuration;
    
    [self.videoPlayerView.playerControlView.portraitControlView syncplayProgress:draggedValue];
    [self.videoPlayerView.playerControlView.landScapeControlView syncplayProgress:draggedValue];
    [self.videoPlayerView.playerControlView.portraitControlView syncplayTime:self.sumTime];
    [self.videoPlayerView.playerControlView.landScapeControlView syncplayTime:self.sumTime];
    
    // 展示快进/快退view
    [self.videoPlayerView.playerControlView showFastView:self.sumTime totalTime:totaYJMovieDuration isForward:style];
    
}

/** pan结束水平移动 */
- (void)panHorizontalEndMoved {
    // 隐藏快进/快退view
    [self.videoPlayerView.playerControlView hideFastView];
    
    // seekTime
    self.playerStatusModel.pauseByUser = NO;
    __weak typeof(self) wself = self;
    [self.playerMgr seekToTime:self.sumTime completionHandler:^{
        [wself.playerMgr play];
    }];
    self.sumTime = 0;
    self.playerStatusModel.dragged = NO;
}

/** 音量改变 */
- (void)volumeValueChange:(CGFloat)value {
    [self.playerMgr changeVolume:value];
}

#pragma mark - YJIJKLoadingViewDelegate
/** 返回按钮被点击 */
- (void)loadingViewBackButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerBackButtonClick)]) {
        [self.delegate playerBackButtonClick];
    }
}

#pragma mark - YJIJKCoverControlViewDelegate
/** 返回按钮被点击 */
- (void)coverControlViewBackButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerBackButtonClick)]) {
        [self.delegate playerBackButtonClick];
    }
}
/** 封面图片Tap事件 */
- (void)coverControlViewBackgroundImageViewTapAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlViewTapAction)]) {
        [self.delegate controlViewTapAction];
    }
}

#pragma mark - 对象释放

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self destroyVideo];
}

@end
