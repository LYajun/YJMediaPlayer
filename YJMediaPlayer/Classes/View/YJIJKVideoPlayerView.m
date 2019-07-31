//
//  YJIJKVideoPlayerView.m
//  IJK播放器Demo
//
//  Created by 刘亚军 on 2017/3/28.
//  Copyright © 2017年 lamiantv. All rights reserved.
//

#import "YJIJKVideoPlayerView.h"
#import <Masonry/Masonry.h>
#import "YJIJKBrightnessView.h"
#import "YJIJKPlayerStatusModel.h"
#import "UIView+YJIJKPlayerView.h"
#import "UIColor+YJIJKPlayerView.h"
#import "YJIJKLrcView.h"
#import "YJIJKSrtModel.h"
#import "UIImage+YJIJKPlayerView.h"


#define kMFDevice_Width  [[UIScreen mainScreen] bounds].size.width
#define kMFDevice_Height [[UIScreen mainScreen] bounds].size.height
// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontaYJMoved, // 横向移动
    PanDirectionVerticaYJMoved    // 纵向移动
};

@interface YJIJKVideoPlayerView ()<UIGestureRecognizerDelegate>
@property (nonatomic, weak) id<YJIJKVideoPlayerViewDelagate> delegate;
@property (nonatomic, weak) UIView *videoView;

// AVPlayerLayer视图容器层
@property (nonatomic, weak) UIView *playerLayerView;
// 控制，互动层
@property (nonatomic, strong) YJIJKPlayerControlView *playerControlView;
/** 播放器的参数模型 */
@property (nonatomic, strong) YJIJKPlayerStatusModel *playerStatusModel;

@property (nonatomic, strong) UILabel *videoSubLab;
@property (nonatomic, strong) YJIJKLrcView *lrcView;
@property (nonatomic, strong) UIView *voiceBgView;
@property (nonatomic, strong) UIImageView *voiceBgImg;
/** 是否在调节音量 */
@property (nonatomic, assign) BOOL isVolume;
/** 定义一个实例变量，保存枚举值 */
@property (nonatomic, assign) PanDirection panDirection;
/** 单击 */
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
/** 双击 */
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
/** 滑动 */
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

/** 当前旋转方向 */
@property(nonatomic,assign)UIInterfaceOrientation currentOrientation;
/** 系统状态栏 */
@property(nonatomic,strong)UIView *statusBar;
@end

@implementation YJIJKVideoPlayerView
#pragma mark - override

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    // 被添加新的父视图中的时候
    
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    // 已被添加到父视图中
    
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

// !!!: 创建对象
+ (instancetype)videoPlayerViewWithSuperView:(UIView *)superview delegate:(id<YJIJKVideoPlayerViewDelagate>)delegate playerStatusModel:(YJIJKPlayerStatusModel *)playerStatusModel {
    
    YJIJKVideoPlayerView *instance = [[YJIJKVideoPlayerView alloc] init];
    instance.videoView = superview;
    instance.delegate = delegate;
    instance.playerStatusModel = playerStatusModel;
    
    [instance addToSuperView:superview];
//    [instance ui];
//    [instance listeningRotating];
//    [instance createGesture]; //
    
    
    [instance addSubviewWithCons];
    
    return instance;
}

- (void)addSubviewWithCons {
    [self addSubview:self.loadingView];
    [self addSubview:self.coverControlView]; // 最后添加, 放在最外面
    
    [self.coverControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self);
    }];
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
}

// 此方法代码需要调用多次，所以封装在一块方法里
- (void)addToSuperView:(UIView *)superView {
    
    if ([self superview] == superView) {
        return;
    }
    
    if ([self superview]) {
        [self removeFromSuperview];
    }
    
//    self.frame = superView.bounds;
    [superView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(superView);
    }];
}

- (void)ui {
    if (_playerControlView && _playerControlView.superview) {
        return;
    }
    
    // !!!: 控制层，互动层(自定义层）
    [self insertSubview:self.playerControlView aboveSubview:self.playerLayerView];
    [self.playerControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self);
    }];
    [self layoutSrtView];
}

#pragma mark - 手势
/**
 *  创建手势
 */
- (void)createGesture {
    if (self.singleTap || self.doubleTap || self.panRecognizer) {
        [self removeGestureRecognizer:self.singleTap];
        [self removeGestureRecognizer:self.doubleTap];
        [self removeGestureRecognizer:self.panRecognizer];
    }
    
    // 单击
    self.singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
    self.singleTap.delegate                = self;
    self.singleTap.numberOfTouchesRequired = 1; //手指数
    self.singleTap.numberOfTapsRequired    = 1;
    [self addGestureRecognizer:self.singleTap];
    
    // 双击(播放/暂停)
    self.doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    self.doubleTap.delegate                = self;
    self.doubleTap.numberOfTouchesRequired = 1; //手指数
    self.doubleTap.numberOfTapsRequired    = 2;
    
    [self addGestureRecognizer:self.doubleTap];
    
    // 解决点击当前view时候响应其他控件事件
    [self.singleTap setDelaysTouchesBegan:YES];
    [self.doubleTap setDelaysTouchesBegan:YES];
    // 双击失败响应单击事件
    [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
    
    // 添加平移手势，用来控制音量、亮度、快进快退
    self.panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
    self.panRecognizer.delegate = self;
    [self.panRecognizer setMaximumNumberOfTouches:1];
    [self.panRecognizer setDelaysTouchesBegan:YES];
    [self.panRecognizer setDelaysTouchesEnded:YES];
    [self.panRecognizer setCancelsTouchesInView:YES];
    [self addGestureRecognizer:self.panRecognizer];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.playerStatusModel.isAutoPlay) {
        UITouch *touch = [touches anyObject];
        if(touch.tapCount == 1) {
            [self performSelector:@selector(singleTapAction:) withObject:nil ];
        } else if (touch.tapCount == 2) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapAction:) object:nil];
            [self doubleTapAction:touch.gestureRecognizers.lastObject];
        }
    }
}

#pragma mark - Action

/**
 *   轻拍方法
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)singleTapAction:(UIGestureRecognizer *)gesture {
//    if ([gesture isKindOfClass:[NSNumber class]] && ![(id)gesture boolValue]) {
//        [self _fullScreenAction];
//        return;
//    }
    
//    if (gesture.state == UIGestureRecognizerStateRecognized) {
    
        if (self.playerStatusModel.playDidEnd) { return; }
        if (self.playerStatusModel.playFailure) { return; }
        if (self.playerControlView.isShowing) {
            [self.playerControlView hideControl];
        } else {
            [self.playerControlView showControl];
        }
//    }
}

/**
 *  双击播放/暂停
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)doubleTapAction:(UIGestureRecognizer *)gesture {
    if (self.playerStatusModel.playDidEnd) { return;  }
    if (self.playerStatusModel.playFailure) { return; }
    
    // 显示控制层
    [self.playerControlView setIsShowing:NO];
    [self.playerControlView showControl];
    
    if ([self.delegate respondsToSelector:@selector(doubleTapAction)]) {
        [self.delegate doubleTapAction];
    }
}

#pragma mark - 监听屏幕自动旋转

/**
 *  监听设备旋转通知
 */
- (void)listeningRotating {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}

/**
 *  屏幕方向发生变化会调用这里
 */
- (void)onDeviceOrientationChange {
    
    if (!YJIJKBrightnessViewShared.isStartPlay || !_playerControlView) {
        return;
    }
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || orientation == UIDeviceOrientationPortraitUpsideDown) { return; }
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        if (orientation == UIDeviceOrientationLandscapeLeft) {
            [self setOrientationLandscapeConstraint:UIInterfaceOrientationLandscapeLeft];
        }else{
            [self setOrientationLandscapeConstraint:UIInterfaceOrientationLandscapeRight];
        }
    
    
    } else {
        [self setOrientationPortraitConstraint];
    }
    [self layoutIfNeeded];
}

/**
 *  设置横屏状态
 */
- (void)setOrientationLandscapeConstraint:(UIInterfaceOrientation)orientation {
    // 非全屏状态切换为全屏
    if (!self.playerStatusModel.isFullScreen) {
        [UIApplication sharedApplication].statusBarHidden = YES;
    }
    if ([self isShowSrtInfo]) {
        self.videoSubLab.hidden = NO;
    }
    self.playerStatusModel.fullScreen = YES;
    
    if (self.playerStatusModel.playDidEnd && _playerControlView) {
        [self.playerControlView playEndHideControlView];
//        return;
    }
    
    
    // 如果当前正在现显示制栏, 屏幕切换时就显示
    if (self.playerControlView.showing) {
        [self.playerControlView setIsShowing:NO];
        [self.playerControlView showControl];
    }
    
    if (orientation == self.currentOrientation) {
        return;
    }
    //设置是否隐藏
    self.statusBar.hidden = YES;
    
    [self removeFromSuperview];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    //播放器所在控制器不支持旋转，采用旋转view的方式实现
    if (orientation == UIInterfaceOrientationLandscapeLeft){
        [UIView animateWithDuration:0.25 animations:^{
            self.transform = CGAffineTransformMakeRotation(M_PI / 2);
        }];
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
    }else if (orientation == UIInterfaceOrientationLandscapeRight) {
        [UIView animateWithDuration:0.25 animations:^{
            self.transform = CGAffineTransformMakeRotation( - M_PI / 2);
        }];
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
    }
    
    CGFloat screenW = (kMFDevice_Width > kMFDevice_Height) ? kMFDevice_Width : kMFDevice_Height;
    CGFloat screenH = (kMFDevice_Width > kMFDevice_Height) ? kMFDevice_Height : kMFDevice_Width;
    
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(screenW));
        make.height.equalTo(@(screenH));
        make.center.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    self.currentOrientation = orientation;
}

/**
 *  设置竖屏状态
 */
- (void)setOrientationPortraitConstraint {
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.playerStatusModel.fullScreen = NO;
    
    if (self.playerStatusModel.playDidEnd) {
        [self.playerControlView playEndHideControlView];
//        return;
    }
    
    
    if ([self isShowSrtInfo]) {
        self.videoSubLab.hidden = self.portraitSrtInvisible;
    }
    
    // 如果当前正在现显示制栏, 屏幕切换时就显示
    if (self.playerControlView.showing) {
        [self.playerControlView setIsShowing:NO];
        [self.playerControlView showControl];
    }
    self.statusBar.hidden = NO;
    if (UIInterfaceOrientationPortrait == self.currentOrientation) {
        return;
    }
    //还原
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
    }];

    [self removeFromSuperview];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    [self.videoView addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
    self.currentOrientation = UIInterfaceOrientationPortrait;
}

#pragma mark - 竖屏横屏
/**
 *  强制屏幕转屏
 *
 *  @param orientation 屏幕方向
 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    // arc下
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

#pragma mark - UIPanGestureRecognizer手势方法
/**
 *  pan手势事件
 *
 *  @param pan UIPanGestureRecognizer
 */
- (void)panDirection:(UIPanGestureRecognizer *)pan {
    // 根据在view上Pan的位置，确定是调音量还是亮度
    CGPoint locationPoint = [pan locationInView:self];
    
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                self.panDirection = PanDirectionHorizontaYJMoved;
                if ([self.delegate respondsToSelector:@selector(panHorizontalBeginMoved)]) {
                    [self.delegate panHorizontalBeginMoved];
                }
            }
            else if (x < y){ // 垂直移动
                self.panDirection = PanDirectionVerticaYJMoved;
                // 开始滑动的时候,状态改为正在控制音量
                if (locationPoint.x > self.bounds.size.width / 2) {
                    self.isVolume = YES;
                }else { // 状态改为显示亮度调节
                    self.isVolume = NO;
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (self.panDirection) {
                case PanDirectionHorizontaYJMoved:{
                    if ([self.delegate respondsToSelector:@selector(panHorizontaYJMoving:)]) {
                        [self.delegate panHorizontaYJMoving:veloctyPoint.x];
                    }
                    break;
                }
                case PanDirectionVerticaYJMoved:{
                    [self verticaYJMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
                case PanDirectionHorizontaYJMoved:{
                    if ([self.delegate respondsToSelector:@selector(panHorizontalEndMoved)]) {
                        [self.delegate panHorizontalEndMoved];
                    }
                    break;
                }
                case PanDirectionVerticaYJMoved:{
                    // 垂直移动结束后，把状态改为不再控制音量
                    self.isVolume = NO;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

/**
 *  pan垂直移动的方法
 *
 *  @param value void
 */
- (void)verticaYJMoved:(CGFloat)value {
    if (self.isVolume && !self.isMute) {
        if ([self.delegate respondsToSelector:@selector(volumeValueChange:)]) {
            [self.delegate volumeValueChange:value];
        }
    } else {
        ([UIScreen mainScreen].brightness -= value / 10000);
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if (self.playerStatusModel.playDidEnd){
            return NO;
        }
    }
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
//        if (self.isBottomVideo && !self.isFullScreen) {
//            return NO;
//        }
    }
    if ([touch.view isKindOfClass:[UISlider class]]) {
        return NO;
    }
    
    return YES;
}
- (void)currentPlayProgress:(CGFloat)progress{
    if (self.isShowSrtInfo) {
        if (self.srtModel.subTitleType == 0) {
            self.lrcView.currentTime = progress * self.duration;
        }else{
            [self setVideoSrtCurrentTime:progress * self.duration];
        }
    }
}
- (void)setVideoSrtCurrentTime:(CGFloat)currentTime{
    YJIJKSrtInfoModel *firstInfo = self.srtModel.srtList.firstObject;
    if (currentTime < firstInfo.beginTime) {
        [self setVideoSubLabAttributedTextWithText:firstInfo.subtitles];
    }else{
        for (int i = 0; i < self.srtModel.srtList.count; i++) {
            YJIJKSrtInfoModel *currentInfo = self.srtModel.srtList[i];
            if (currentTime >= currentInfo.beginTime &&
                currentTime < currentInfo.endTime) {
                 [self setVideoSubLabAttributedTextWithText:currentInfo.subtitles];
                break;
            }
        }
    }
}
- (void)setVideoSubLabAttributedTextWithText:(NSString *)text{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text];
    [attr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20]range:NSMakeRange(0,attr.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,attr.length)];
    [attr addAttribute:NSStrokeWidthAttributeName value:@(-2) range:NSMakeRange(0,attr.length)];
    [attr addAttribute:NSStrokeColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,attr.length)];
    self.videoSubLab.attributedText = attr;
}
- (BOOL)isShowSrtInfo{
    if (self.srtModel && self.srtModel.srtList && self.srtModel.srtList.count > 0) {
        return YES;
    }
    return NO;
}
- (void)layoutSrtView{
    if (self.isShowSrtInfo) {
        if (self.srtModel.subTitleType == 0) {// 音频字幕
            [self insertSubview:self.lrcView belowSubview:self.playerControlView];
            [self.lrcView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.top.equalTo(self);
                make.left.equalTo(self);
            }];
            self.lrcView.srtModel = self.srtModel;
        }else{
            [self insertSubview:self.videoSubLab belowSubview:self.playerControlView];
            [self.videoSubLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self).offset(-10);
                make.left.equalTo(self).offset(30);
            }];
            [self setVideoSrtCurrentTime:0];
            self.videoSubLab.hidden = self.portraitSrtInvisible;
        }
    }else if (self.isShowVoiceBgImg){
        [self insertSubview:self.voiceBgView belowSubview:self.playerControlView];
        [self.voiceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.voiceBgView addSubview:self.voiceBgImg];
        [self.voiceBgImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.voiceBgView);
            make.top.equalTo(self.voiceBgView).offset(40);
            make.width.equalTo(self.voiceBgImg.mas_height);
        }];
    }
}
#pragma mark - Public method
- (void)setSrtModel:(YJIJKSrtModel *)srtModel{
    _srtModel = srtModel;
}
- (void)setPlayerLayerView:(UIView *)playerLayerView {
    _playerLayerView = playerLayerView;
    [self insertSubview:playerLayerView atIndex:0];
    [playerLayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self);
    }];
}

/** 重置VideoPlayerView */
- (void)playerResetVideoPlayerView {
    [self.playerControlView playerResetControlView];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)shrinkOrFullScreen:(BOOL)isFull {
    if (isFull) { // 设置全屏
//        [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        [self setOrientationLandscapeConstraint:UIInterfaceOrientationLandscapeLeft];
    } else {
//        [self interfaceOrientation:UIInterfaceOrientationPortrait];
        [self setOrientationPortraitConstraint];
    }
}

/**
 *  播放完成时隐藏控制层
 */
- (void)playDidEnd {
    [self.playerControlView playDidEnd];
}

/**
 *  重新播放
 */
- (void)repeatPlay {
    // 重置控制层View
    [self.playerControlView playerResetControlView];
    [self.playerControlView showControl];
}

/**
 *  开始准备播放
 */
- (void)startReadyToPlay {
    // 1. 设置子控制层
    [self ui];
    // 2. 添加手势
    if (!self.singleTap || !self.doubleTap || !self.panRecognizer) {
        [self createGesture];
    }
    // 3. 设置viewTimeView
    [self.playerControlView startReadyToPlay];
    
    // 4.监听屏幕旋转
    [self listeningRotating];
}

/**
 *  视频加载失败
 */
- (void)loadFailed {
    // 1. 设置子控制层
    [self ui];
    
    // 2.监听屏幕旋转
    [self listeningRotating];
}

#pragma mark - getter
- (UIView *)statusBar{
    if (!_statusBar){
        _statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    }
    return _statusBar;
}
- (YJIJKPlayerControlView *)playerControlView {
    if (!_playerControlView) {
        _playerControlView = [YJIJKPlayerControlView playerControlViewWithStatusModel:self.playerStatusModel];
    }
    return _playerControlView;
}

- (YJIJKCoverControlView *)coverControlView {
    if (!_coverControlView) {
        _coverControlView = [[YJIJKCoverControlView alloc] init];
    }
    return _coverControlView;
}

- (YJIJKLoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[YJIJKLoadingView alloc] init];
    }
    return _loadingView;
}
- (UILabel *)videoSubLab{
    if (!_videoSubLab) {
        _videoSubLab = [UILabel new];
        _videoSubLab.textAlignment = NSTextAlignmentCenter;
        _videoSubLab.textColor = [UIColor whiteColor];
        _videoSubLab.font = [UIFont systemFontOfSize:15];
        _videoSubLab.numberOfLines = 0;
    }
    return _videoSubLab;
}
- (YJIJKLrcView *)lrcView{
    if (!_lrcView) {
        _lrcView = [[YJIJKLrcView alloc] initWithFrame:CGRectZero];
        [_lrcView yjijk_setGradientBackgroundWithColors:@[YJIJKPlayView_ColorWithHex(0x4094b6),YJIJKPlayView_ColorWithHex(0xbabee0)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
        _lrcView.userInteractionEnabled = NO;
    }
    return _lrcView;
}
- (UIView *)voiceBgView{
    if (!_voiceBgView) {
        _voiceBgView = [[UIView alloc] initWithFrame:CGRectZero];
        [_voiceBgView yjijk_setGradientBackgroundWithColors:@[YJIJKPlayView_ColorWithHex(0x4094b6),YJIJKPlayView_ColorWithHex(0xbabee0)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    }
    return _voiceBgView;
}
- (UIImageView *)voiceBgImg{
    if (!_voiceBgImg) {
         _voiceBgImg = [[UIImageView alloc] initWithImage:[UIImage yjijk_imageNamed:@"yj_restype_voice"]];
    }
    return _voiceBgImg;
}
#pragma mark - 释放对象
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
