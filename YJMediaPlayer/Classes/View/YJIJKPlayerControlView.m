//
//  YJIJKPlayerControlView.m
//  lamiantv
//
//  Created by 刘亚军 on 2016/12/2.
//  Copyright © 2016年 AiPai. All rights reserved.
//

#import "YJIJKPlayerControlView.h"
#import "YJIJKMaterialDesignSpinner.h"
#import <Masonry/Masonry.h>
#import "UIColor+YJIJKPlayerView.h"
#import "YJIJKPlayerStatusModel.h"
#import "UIView+YJIJKPlayerView.h"
#import "UIImage+YJIJKPlayerView.h"

static const CGFloat YJIJKPlayerAnimationTimeInterval             = 7.0f;
static const CGFloat YJIJKPlayerControlBarAutoFadeOutTimeInterval = 0.35f;

@interface YJIJKPlayerControlView ()
/** 加载loading */
@property (nonatomic, strong) YJIJKMaterialDesignSpinner *activity;
/** 快进快退View */
@property (nonatomic, strong) UIView                  *fastView;
/** 快进快退进度progress */
@property (nonatomic, strong) UIProgressView          *fastProgressView;
/** 快进快退时间 */
@property (nonatomic, strong) UILabel                 *fastTimeLabel;
/** 快进快退ImageView */
@property (nonatomic, strong) UIImageView             *fastImageView;
/** 加载失败按钮 */
@property (nonatomic, strong) UIButton                *failBtn;
/** 重播按钮 */
@property (nonatomic, strong) UIButton                *repeatBtn;

/** 是否显示了控制层 */
@property (nonatomic, assign, getter=isShowing) BOOL  showing;
/** 是否播放结束 */
@property (nonatomic, assign, getter=isPlayEnd) BOOL  playeEnd;
/** 播放器的参数模型 */
@property (nonatomic, strong) YJIJKPlayerStatusModel *playerStatusModel;
@end

@implementation YJIJKPlayerControlView

+ (instancetype)playerControlViewWithStatusModel:(YJIJKPlayerStatusModel *)playerStatusModel {
    YJIJKPlayerControlView *instance = [[self alloc] init];
    instance.playerStatusModel = playerStatusModel;
    return instance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        // 添加所有子控件
        [self addAllSubViews];
        
        // 设置子控件的响应事件
        [self makeSubViewsAction];
        
        // 添加子控件的约束
        [self makeSubViewsConstraints];
        
        self.landScapeControlView.hidden = YES;
        
        // 初始化时重置controlView
        [self playerResetControlView];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutIfNeeded];
}

/**
 *  添加所有子控件
 */
- (void)addAllSubViews {
    [self addSubview:self.portraitControlView];
    [self addSubview:self.landScapeControlView];
    [self addSubview:self.activity];
    [self addSubview:self.repeatBtn];
    [self addSubview:self.failBtn];
    
    [self addSubview:self.fastView];
    [self.fastView addSubview:self.fastImageView];
    [self.fastView addSubview:self.fastTimeLabel];
    [self.fastView addSubview:self.fastProgressView];

}

// 设置子控件的响应事件
- (void)makeSubViewsAction {
    [self.failBtn addTarget:self action:@selector(failBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.repeatBtn addTarget:self action:@selector(repeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - Action

/** 播放失败按钮的点击 */
- (void)failBtnClick:(UIButton *)sender {
    self.failBtn.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(failButtonClick)]) {
        [self.delegate failButtonClick];
    }
}

/** 重播按钮的点击 */
- (void)repeatBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(repeatButtonClick)]) {
        [self.delegate repeatButtonClick];
    }
}


#pragma mark - Private Method

/**
 *  显示控制层
 */
- (void)showControlView {
    if (self.playerStatusModel.isFullScreen) {
        // 横屏
        self.landScapeControlView.hidden = NO;
        self.portraitControlView.hidden = YES;
    } else {
        // 竖屏
        self.portraitControlView.hidden = NO;
        self.landScapeControlView.hidden = YES;
    }

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

/**
 *  隐藏控制层
 */
- (void)hideControlView {
    self.landScapeControlView.hidden = YES;
    self.portraitControlView.hidden = YES;
    if (self.playerStatusModel.isFullScreen && !self.playeEnd) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
}

/**
 *  自动隐藏控制层
 */
- (void)autoFadeOutControlView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControl) object:nil];
    [self performSelector:@selector(hideControl) withObject:nil afterDelay:YJIJKPlayerAnimationTimeInterval];
}

/**
 *  取消延时隐藏controlView的方法
 */
- (void)playerCancelAutoFadeOutControlView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControl) object:nil];
}

#pragma mark - Public method
/** 初始化时重置controlView */
- (void)playerResetControlView {
    [self.portraitControlView playerResetControlView];
    [self.landScapeControlView playerResetControlView];
    
    self.fastView.hidden = YES;
    self.repeatBtn.hidden = YES;
    self.failBtn.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    self.showing = NO;
    self.playeEnd = NO;
//    self.dragged = NO;
    
}

/** 切换分辨率时 - 重置控制层 */
- (void)playerResetControlViewForResolution {
    self.fastView.hidden        = YES;
    self.backgroundColor        = [UIColor clearColor];
    self.showing                = NO;
    self.failBtn.hidden         = YES;
    self.repeatBtn.hidden       = YES;
    
}

/**
 *  开始准备播放
 */
- (void)startReadyToPlay {
 
#warning 可以考虑, 在这里才加载部分UI
    
    // 显示controlView
    [self showControl];
}

/** 显示状态栏 */
- (void)showStatusBar {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

/** 显示控制层 */
- (void)showControl {
    if (self.isShowing) {
        [self hideControl];
        return;
    }
    [self playerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:YJIJKPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self showControlView];
    } completion:^(BOOL finished) {
        self.showing = YES;
        [self autoFadeOutControlView];
    }];
}

/** 隐藏控制层 */
- (void)hideControl {
    if (!self.isShowing) { return; }
    [self playerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:YJIJKPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self hideControlView];
    }completion:^(BOOL finished) {
        self.showing = NO;
    }];
}

/** 强行设置是否显示了控制层 */
- (void)setIsShowing:(BOOL)showing {
    self.showing = showing;
}


/** 显示快进视图 */
- (void)showFastView:(NSInteger)draggedTime totalTime:(NSInteger)totalTime isForward:(BOOL)forawrd {
    [self.activity stopAnimating];
    
    // 拖拽的时长
    NSInteger proMin = draggedTime / 60;//当前秒
    NSInteger proSec = draggedTime % 60;//当前分钟
    
    //duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    NSString *totalTimeStr   = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    CGFloat  draggedValue    = (CGFloat)draggedTime/(CGFloat)totalTime;
    NSString *timeStr        = [NSString stringWithFormat:@"%@ / %@", currentTimeStr, totalTimeStr];
    if (forawrd) {
        self.fastImageView.image = [UIImage imageNamed:@"ZFPlayer_fast_forward"];
    } else {
        self.fastImageView.image = [UIImage imageNamed:@"ZFPlayer_fast_forward"];
    }
    self.fastView.hidden           = NO;
    self.fastTimeLabel.text        = timeStr;
    self.fastProgressView.progress = draggedValue;
}

/** 隐藏快进视图 */
- (void)hideFastView {
    self.fastView.hidden = YES;
}


/** 准备开始播放, 隐藏loading */
- (void)readyToPlay {
    [self.activity stopAnimating];
    self.failBtn.hidden = YES;
}

/** 加载失败, 显示加载失败按钮 */
- (void)loadFailed {
    [self.activity stopAnimating];
    self.failBtn.hidden = NO;
}

/** 开始loading */
- (void)loading {
    [self.activity startAnimating];
    self.failBtn.hidden = YES;
    self.fastView.hidden = YES; //
    
#warning 有问题, 可能重播播放的是本地文件, 就不会loading(待优化)
    self.playeEnd = NO;
}

/** 播放完了, 显示重播按钮 */
- (void)playDidEnd {
    [self.activity stopAnimating];
    self.failBtn.hidden = YES;
    self.repeatBtn.hidden = NO;
    
    self.backgroundColor  = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    self.playeEnd         = YES;
    self.showing          = NO;
    // 隐藏controlView
    [self playEndHideControlView];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

/**
 *  播放完成时隐藏控制层
 */
- (void)playEndHideControlView {
    if (self.playerStatusModel.isFullScreen) {
        // 横屏
        self.portraitControlView.hidden = YES;
        self.landScapeControlView.hidden = NO;
        
        [self.landScapeControlView playEndHideView:self.playeEnd];
    } else {
        // 竖屏
        self.landScapeControlView.hidden = YES;
        self.portraitControlView.hidden = NO;
        
        [self.portraitControlView playEndHideView:self.playeEnd];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

#pragma mark - 添加子控件的约束
/**
 *  添加子控件的约束
 */
- (void)makeSubViewsConstraints {
    
    [self.portraitControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self);
    }];
    
    [self.landScapeControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self);
    }];
    
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.with.height.mas_equalTo(30);
    }];
    
    [self.repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(90, 40));
    }];
    [self.repeatBtn yjijk_clipLayerWithRadius:3 width:0 color:nil];
    [self.failBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(33);
    }];
    
    [self.failBtn yjijk_clipLayerWithRadius:3 width:0 color:nil];
    [self.fastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(125);
        make.height.mas_equalTo(80);
        make.center.equalTo(self);
    }];
    
    [self.fastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(32);
        make.height.mas_offset(32);
        make.top.mas_equalTo(5);
        make.centerX.mas_equalTo(self.fastView.mas_centerX);
    }];
    
    [self.fastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.with.trailing.mas_equalTo(0);
        make.top.mas_equalTo(self.fastImageView.mas_bottom).offset(2);
    }];
    
    [self.fastProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(12);
        make.trailing.mas_equalTo(-12);
        make.top.mas_equalTo(self.fastTimeLabel.mas_bottom).offset(10);
    }];
}

#pragma mark - getter

- (YJIJKPortraitControlView *)portraitControlView {
    if (!_portraitControlView) {
        _portraitControlView = [[YJIJKPortraitControlView alloc] init];
    }
    return _portraitControlView;
}

- (YJIJKLandScapeControlView *)landScapeControlView {
    if (!_landScapeControlView) {
        _landScapeControlView = [[YJIJKLandScapeControlView alloc] init];
    }
    return _landScapeControlView;
}

- (YJIJKMaterialDesignSpinner *)activity {
    if (!_activity) {
        _activity = [[YJIJKMaterialDesignSpinner alloc] init];
        _activity.lineWidth = 2;
        _activity.duration  = 1;
        _activity.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    }
    return _activity;
}

- (UIView *)fastView {
    if (!_fastView) {
        _fastView                     = [[UIView alloc] init];
        _fastView.backgroundColor     = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        _fastView.layer.cornerRadius  = 4;
        _fastView.layer.masksToBounds = YES;
    }
    return _fastView;
}

- (UIImageView *)fastImageView {
    if (!_fastImageView) {
        _fastImageView = [[UIImageView alloc] init];
    }
    return _fastImageView;
}

- (UILabel *)fastTimeLabel {
    if (!_fastTimeLabel) {
        _fastTimeLabel               = [[UILabel alloc] init];
        _fastTimeLabel.textColor     = [UIColor whiteColor];
        _fastTimeLabel.textAlignment = NSTextAlignmentCenter;
        _fastTimeLabel.font          = [UIFont systemFontOfSize:14.0];
    }
    return _fastTimeLabel;
}

- (UIProgressView *)fastProgressView {
    if (!_fastProgressView) {
        _fastProgressView                   = [[UIProgressView alloc] init];
        _fastProgressView.progressTintColor = [UIColor whiteColor];
        _fastProgressView.trackTintColor    = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    }
    return _fastProgressView;
}

- (UIButton *)failBtn {
    if (!_failBtn) {
        _failBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_failBtn setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];
        [_failBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _failBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _failBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _failBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
         _failBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:1.0];
    }
    return _failBtn;
}

- (UIButton *)repeatBtn {
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _repeatBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:1.0];
        [_repeatBtn setImage:[UIImage yjijk_imageNamed:@"lg_update"] forState:UIControlStateNormal];
        [_repeatBtn setTitle:@" 重播" forState:UIControlStateNormal];
        [_repeatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _repeatBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _repeatBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _repeatBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:1.0];
    }
    return _repeatBtn;
}

@end
