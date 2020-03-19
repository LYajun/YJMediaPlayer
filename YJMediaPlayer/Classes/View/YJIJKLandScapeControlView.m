//
//  YJIJKLandScapeControlView.m
//  拉面视频Demo
//
//  Created by 刘亚军 on 16/9/1.
//  Copyright © 2016年 lamiantv. All rights reserved.
//  

#import "YJIJKLandScapeControlView.h"

#import <Masonry/Masonry.h>
#import "UIColor+YJIJKPlayerView.h"
#import "UIImage+YJIJKPlayerView.h"
#import "UIButton+YJIJKPlayerRotation.h"
#import "YJIJKPlayerModel.h"
#import "UIView+YJIJKPlayerView.h"
#import "YJIJKMarqueeLabel.h"

@interface YJIJKLandScapeControlView ()
/** 顶部工具栏 */
@property (nonatomic, strong) UIView *topToolView;
/** 返回按钮 */
@property (nonatomic, strong) UIButton *backBtn;
/** 标题 */
@property (nonatomic, strong) YJIJKMarqueeLabel *titleLabel;

/** 底部工具栏 */
@property (nonatomic, strong) UIView *bottomToolView;
/** 播放或暂停按钮(小) */
@property (nonatomic, strong) UIButton *playOrPauseBtn;
/** 静音按钮 */
@property (nonatomic, strong) UIButton *muteBtn;
/** 播放的当前时间label */
@property (nonatomic, strong) UILabel *currentTimeLabel;
/** 滑杆 */
@property (nonatomic, strong) UISlider *videoSlider;
/** 缓冲进度条 */
@property (nonatomic, strong) UIProgressView *progressView;
/** 视频总时间 */
@property (nonatomic, strong) UILabel *totalTimeLabel;

@property (nonatomic, strong) UILabel *timeSpaceLab;

@property (nonatomic, assign) double durationTime;
@property (strong,nonatomic) UIView *listeningTestStartPointView;
@property (strong,nonatomic) UIView *listeningTestEndPointView;
@property (strong,nonatomic) UILabel *listeningTestVipPointView;
@end

@implementation YJIJKLandScapeControlView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 添加子控件
        [self addSubview:self.topToolView];
        [self.topToolView addSubview:self.backBtn];
        [self.topToolView addSubview:self.titleLabel];
   
        [self addSubview:self.bottomToolView];
        [self.bottomToolView addSubview:self.playOrPauseBtn];
        [self.bottomToolView addSubview:self.muteBtn];
        [self.bottomToolView addSubview:self.totalTimeLabel];
        [self.bottomToolView addSubview:self.timeSpaceLab];
        [self.bottomToolView addSubview:self.currentTimeLabel];
        [self.bottomToolView addSubview:self.progressView];
        [self.bottomToolView addSubview:self.videoSlider];
   
        // 设置子控件的响应事件
        [self makeSubViewsAction];
        
        // 添加子控件的约束
        [self makeSubViewsConstraints];
        
    }
    return self;
}

- (void)makeSubViewsAction {
    [self.backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playOrPauseBtn addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    self.backBtn.yjijk_touchAreaInsets = UIEdgeInsetsMake(10, 10, 10, 20);
    [self.muteBtn addTarget:self action:@selector(muteButtonClickAction:) forControlEvents:UIControlEventTouchDown];
    UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
    [self.videoSlider addGestureRecognizer:sliderTap];
    
    // slider开始滑动事件
    [self.videoSlider addTarget:self action:@selector(progressSliderTouchBeganAction:) forControlEvents:UIControlEventTouchDown];
    // slider滑动中事件
    [self.videoSlider addTarget:self action:@selector(progressSliderValueChangedAction:) forControlEvents:UIControlEventValueChanged];
    // slider结束滑动事件
    [self.videoSlider addTarget:self action:@selector(progressSliderTouchEndedAction:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    
    UITapGestureRecognizer *botTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(botTapAction)];
    [self.bottomToolView addGestureRecognizer:botTap];
    UITapGestureRecognizer *topTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topTapAction)];
    [self.topToolView addGestureRecognizer:topTap];
}
- (void)botTapAction{
    NSLog(@"横屏：botTapAction");
}
- (void)topTapAction{
    NSLog(@"横屏：topTapAction");
}
#pragma mark - action

- (void)backBtnClickAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(landScapeBackButtonClick)]) {
        [self.delegate landScapeBackButtonClick];
    }
}

- (void)playPauseButtonClickAction:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(landScapePlayPauseButtonClick:)]){
        [self.delegate landScapePlayPauseButtonClick:sender.selected];
    }
}
- (void)muteButtonClickAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(landScapeMuteButtonClickWithIsMute:)]) {
        [self.delegate landScapeMuteButtonClickWithIsMute:sender.selected];
    }
}
- (void)progressSliderTouchBeganAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(landScapeProgressSliderBeginDrag)]) {
        [self.delegate landScapeProgressSliderBeginDrag];
    }
}

- (void)progressSliderValueChangedAction:(UISlider *)sender {
    // 拖拽过程中修改playTime
    [self syncplayTime:(sender.value * self.durationTime)];
}

- (void)progressSliderTouchEndedAction:(UISlider *)sender {
    if ([self.delegate respondsToSelector:@selector(landScapeProgressSliderEndDrag:)]) {
        [self.delegate landScapeProgressSliderEndDrag:sender.value];
    }
}

- (void)tapSliderAction:(UITapGestureRecognizer *)tap
{
    if ([tap.view isKindOfClass:[UISlider class]] && [self.delegate respondsToSelector:@selector(landScapeProgressSliderTapAction:)]) {
        UISlider *slider = (UISlider *)tap.view;
        CGPoint point = [tap locationInView:slider];
        CGFloat length = slider.frame.size.width;
        // 视频跳转的value
        CGFloat tapValue = point.x / length;
        
        [self.delegate landScapeProgressSliderTapAction:tapValue];
    }
}
- (void)dealloc{
    [self.titleLabel invalidateTimer];
}
#pragma mark - 添加子控件的约束
- (void)makeSubViewsConstraints {
    CGFloat leftSpace = 0;
     if (@available(iOS 13.0, *)) {
         leftSpace = 20;
     }
    [self.topToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(64);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topToolView);
        make.left.equalTo(self.topToolView).offset(([self yjijk_isIPhoneX] ? [self yjijk_stateBarSpace] : 0) + 6 + leftSpace);
        make.size.mas_equalTo(CGSizeMake(40, 28));
    }];
    if (IsIPad && CGAffineTransformIsIdentity(self.backBtn.transform)) {
        self.backBtn.transform = CGAffineTransformMakeScale(1.3, 1.3);
    }else{
        [self.backBtn setImageEdgeInsets: UIEdgeInsetsMake(0, -10, 0, 0)];
    }
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topToolView);
        make.left.equalTo(self.backBtn.mas_right).offset(20);
        make.right.equalTo(self.topToolView).offset(-20-[self yj_tabBarSpace]);
    }];
    
    [self.bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        if (IsIPad) {
            make.height.mas_equalTo(54);
        }else{
            make.height.mas_equalTo(44);
        }
    }];
    
    [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomToolView);
        make.left.equalTo(self.bottomToolView).offset(([self yjijk_isIPhoneX] ? [self yjijk_stateBarSpace] : 0)+ (IsIPad ? 12 : 6) + leftSpace);
        make.size.mas_equalTo(CGSizeMake(28, 38));
    }];
    [self.muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomToolView);
        make.right.equalTo(self.bottomToolView).offset(([self yjijk_isIPhoneX] ? - [self yj_tabBarSpace] : 0) + (IsIPad ? -15 : -5));
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomToolView);
        make.right.equalTo(self.muteBtn.mas_left).offset(IsIPad ? -10 :-5);
        make.width.mas_equalTo(45);
    }];
    
    [self.timeSpaceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomToolView);
        make.right.equalTo(self.totalTimeLabel.mas_left).offset(0);
        make.width.mas_equalTo(5);
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomToolView);
        make.right.equalTo(self.timeSpaceLab.mas_left).offset(0);
        make.width.mas_equalTo(45);
    }];
    

    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomToolView);
        make.left.equalTo(self.playOrPauseBtn.mas_right).offset(10);
        make.right.equalTo(self.currentTimeLabel.mas_left).offset(-3);
    }];
    
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.left.equalTo(self.progressView);
    }];

    [self.bottomToolView addSubview:self.listeningTestStartPointView];
    [self.listeningTestStartPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.videoSlider);
        make.left.equalTo(self.videoSlider);
        make.width.height.mas_equalTo(6);
    }];
    [self.listeningTestStartPointView yjijk_clipLayerWithRadius:3 width:0 color:nil];
    self.listeningTestStartPointView.hidden = YES;
    
    [self.bottomToolView addSubview:self.listeningTestEndPointView];
    [self.listeningTestEndPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.videoSlider);
        make.left.equalTo(self.videoSlider);
        make.width.height.mas_equalTo(6);
    }];
    [self.listeningTestEndPointView yjijk_clipLayerWithRadius:3 width:0 color:nil];
    self.listeningTestEndPointView.hidden = YES;
    
    [self.bottomToolView addSubview:self.listeningTestVipPointView];
    [self.listeningTestVipPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.videoSlider);
        make.left.equalTo(self.videoSlider);
        make.width.height.mas_equalTo(IsIPad ? 12 : 8);
    }];
    [self.listeningTestVipPointView yjijk_clipLayerWithRadius:IsIPad ? 6 : 4 width:0 color:nil];
    self.listeningTestVipPointView.hidden = YES;
}
- (CGFloat)videoSliderWidth{
    CGFloat otherWidth = (6+28) + (5+28) + (5+45) + 5 + 45 + (10+3);
    if (IsIPad) {
        otherWidth = (12+28) + (15+28) + (10+45) + 5 + 45 + (10+3);
    }
    CGFloat screenWidth = ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height);
    CGFloat width = screenWidth - otherWidth;
    return width;
}
#pragma mark - Public method
/** 重置ControlView */
- (void)playerResetControlView {
    self.videoSlider.value           = 0;
    self.progressView.progress       = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.backgroundColor             = [UIColor clearColor];
    self.playOrPauseBtn.selected = YES;
//    self.titleLabel.text = @"";
    
    self.topToolView.alpha = 1;
    self.bottomToolView.alpha = 1;
    
    self.topToolView.hidden = NO;
    self.bottomToolView.hidden = NO;
}

- (void)playEndHideView:(BOOL)playeEnd {
    self.topToolView.hidden = NO;
    self.bottomToolView.hidden = YES;
}

/** 更新标题 */
- (void)syncTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)syncplayPauseButton:(BOOL)isPlay {
    if (isPlay) {
        self.playOrPauseBtn.selected = YES;
    } else {
        self.playOrPauseBtn.selected = NO;
    }
}

- (void)syncbufferProgress:(double)progress {
    self.progressView.progress = progress;
}

- (void)syncplayProgress:(double)progress {
    self.videoSlider.value = progress;
}

- (void)syncplayTime:(NSInteger)time {
    
    if (time < 0) {
        return;
    }
    NSString *progressTimeString = [self convertTimeSecond:time];
    self.currentTimeLabel.text = progressTimeString;
}

- (void)syncDurationTime:(NSInteger)time {
    
    if (time < 0) {
        return;
    }
    
    self.durationTime = time;
    NSString *durationTimeString = [self convertTimeSecond:time];
    
    if ([self.totalTimeLabel.text isEqualToString:@"00:00"]) {
        if ((self.playerModel.seekStartTime > 0 || self.playerModel.seekEndTime > 0) && self.playerModel.seekEndTime > self.playerModel.seekStartTime) {
            CGFloat startRate = self.playerModel.seekStartTime * 1.0 /self.durationTime;
            self.listeningTestStartPointView.hidden = NO;
            [self.listeningTestStartPointView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.videoSlider).offset(startRate * [self videoSliderWidth]);
            }];
            
            CGFloat endRate = self.playerModel.seekEndTime * 1.0 /self.durationTime;
            if (endRate > 1) {
                endRate = 1;
            }
            self.listeningTestEndPointView.hidden = NO;
            [self.listeningTestEndPointView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.videoSlider).offset(endRate * [self videoSliderWidth]);
            }];
        }
        
        if (self.playerModel.vipLimitTime > 0 && self.durationTime > self.playerModel.vipLimitTime) {
            CGFloat rate = self.playerModel.vipLimitTime * 1.0 /self.durationTime;
            self.listeningTestVipPointView.hidden = NO;
            [self.listeningTestVipPointView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.videoSlider).offset(rate * [self videoSliderWidth]);
            }];
        }
    }
    
    self.totalTimeLabel.text = durationTimeString;
}
- (void)setPlayerModel:(YJIJKPlayerModel *)playerModel{
    _playerModel = playerModel;
    self.muteBtn.selected = playerModel.isMute;
}
#pragma mark - Other
// !!!: 将秒数时间转换成mm:ss
- (NSString *)convertTimeSecond:(NSInteger)second {
    
    NSInteger durMin = second / 60; // 秒
    NSInteger durSec = second % 60; // 分钟
    NSString *timeString = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    
    return timeString;
}


#pragma mark - getter
- (UIView *)topToolView {
    if (!_topToolView) {
        _topToolView = [[UIView alloc] init];
        _topToolView.backgroundColor = [UIColor clearColor];
    }
    return _topToolView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage yjijk_imageNamed:@"yj_back"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (YJIJKMarqueeLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YJIJKMarqueeLabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:IsIPad ? 20 : 17];
        _titleLabel.textColor = [UIColor whiteColor];
       _titleLabel.speed = 0.1f;
        _titleLabel.secondLabelInterval = 10;
        _titleLabel.text = @"";
    }
    return _titleLabel;
}
- (UIView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] init];
        _bottomToolView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _bottomToolView;
}

- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBtn setImage:[UIImage yjijk_imageNamed:IsIPad ? @"yj_play_ipad" : @"yj_play"] forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:[UIImage yjijk_imageNamed:IsIPad ? @"yj_pause_ipad" : @"yj_pause"] forState:UIControlStateSelected];
    }
    return _playOrPauseBtn;
}
- (UIButton *)muteBtn{
    if (!_muteBtn) {
        _muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_muteBtn setImage:[UIImage yjijk_imageNamed:IsIPad ? @"yj_unmute_ipad" : @"yj_unmute"] forState:UIControlStateNormal];
        [_muteBtn setImage:[UIImage yjijk_imageNamed:IsIPad ? @"yj_mute_ipad" : @"yj_mute"] forState:UIControlStateSelected];
    }
    return _muteBtn;
}
- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentRight;
        _currentTimeLabel.text = @"00:00";
    }
    return _currentTimeLabel;
}

- (UISlider *)videoSlider {
    if (!_videoSlider) {
        _videoSlider = [[UISlider alloc] initWithFrame:CGRectZero];
        _videoSlider.maximumValue = 1;
        _videoSlider.minimumTrackTintColor = YJIJKPlayView_ColorWithHex(0x00A0E9);
        _videoSlider.maximumTrackTintColor = [UIColor clearColor];
        [_videoSlider setThumbImage:[UIImage yjijk_imageNamed:IsIPad ? @"yj_thumb_ipad" : @"yj_thumb"] forState:UIControlStateNormal];
    }
    return _videoSlider;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor lightGrayColor];
        _progressView.trackTintColor = [UIColor darkGrayColor];
    }
    return _progressView;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [UILabel new];
        _totalTimeLabel.font = [UIFont systemFontOfSize:14];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.text = @"00:00";
    }
    return _totalTimeLabel;
}

- (UILabel *)timeSpaceLab{
    if (!_timeSpaceLab) {
        _timeSpaceLab = [UILabel new];
        _timeSpaceLab.font = [UIFont systemFontOfSize:12];
        _timeSpaceLab.textColor = [UIColor whiteColor];
        _timeSpaceLab.textAlignment = NSTextAlignmentCenter;
        _timeSpaceLab.text = @"/";
    }
    return _timeSpaceLab;
}
- (UIView *)listeningTestEndPointView{
    if (!_listeningTestEndPointView) {
        _listeningTestEndPointView = [UIView new];
        _listeningTestEndPointView.backgroundColor = [UIColor yjijk_colorWithHex:0x46C2F8];
    }
    return _listeningTestEndPointView;
}
- (UIView *)listeningTestStartPointView{
    if (!_listeningTestStartPointView) {
        _listeningTestStartPointView = [UIView new];
        _listeningTestStartPointView.backgroundColor = [UIColor yjijk_colorWithHex:0x46C2F8];
    }
    return _listeningTestStartPointView;
}
- (UILabel *)listeningTestVipPointView{
    if (!_listeningTestVipPointView) {
        _listeningTestVipPointView = [UILabel new];
        _listeningTestVipPointView.text = @"V";
        _listeningTestVipPointView.textColor = [UIColor whiteColor];
        _listeningTestVipPointView.textAlignment = NSTextAlignmentCenter;
        _listeningTestVipPointView.font = [UIFont systemFontOfSize:IsIPad ? 8 : 6 weight:UIFontWeightMedium];
        _listeningTestVipPointView.backgroundColor = [UIColor redColor];
    }
    return _listeningTestVipPointView;
}
@end
