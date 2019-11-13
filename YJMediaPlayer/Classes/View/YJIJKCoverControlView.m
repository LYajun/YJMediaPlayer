//
//  YJIJKCoverView.m
//  拉面视频Demo
//
//  Created by 刘亚军 on 16/9/26.
//  Copyright © 2016年 lamiantv. All rights reserved.
//  未播放状态下的封面

#import "YJIJKCoverControlView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+YJIJKPlayerView.h"
#import "UIView+YJIJKPlayerView.h"
#import "UIColor+YJIJKPlayerView.h"

@interface YJIJKCoverControlView ()
/** 背景图片 */
@property (nonatomic, strong) UIImageView *backgroundImageView;
/** 返回按钮 */
@property (nonatomic, strong) UIButton *backBtn;

/** 播放Icon */
@property (nonatomic, strong) UIButton *playerImageView;
@end

@implementation YJIJKCoverControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 添加子控件
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.backBtn];
        [self addSubview:self.playerImageView];
        
        // 添加子控件的约束
        [self makeSubViewsConstraints];
        self.backgroundColor = [UIColor blackColor];
        [self makeSubViewsAction];
    }
    return self;
}

- (void)makeSubViewsAction {
    [self.backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];

    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundImageViewTapAction)];
    self.backgroundImageView.userInteractionEnabled = YES;
    [self.backgroundImageView addGestureRecognizer:tapGes];
}

#pragma mark - Action
- (void)backBtnClickAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(coverControlViewBackButtonClick)]) {
        [self.delegate coverControlViewBackButtonClick];
    }
}
- (void)backgroundImageViewTapAction {
    if ([self.delegate respondsToSelector:@selector(coverControlViewBackgroundImageViewTapAction)]) {
        [self.delegate coverControlViewBackgroundImageViewTapAction];
    }
}

#pragma mark - Public method
/** 更新封面图片 */
- (void)syncCoverImageViewWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage {
    // 设置网络占位图片
    if (urlString.length) {
        [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"封面占位"]];;
    } else {
        self.backgroundImageView.image = placeholderImage;
    }
}

#pragma mark - 添加子控件约束
- (void)makeSubViewsConstraints {

    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.left.equalTo(self).offset(6);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    [self.playerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        if (IsIPad) {
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }else{
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }
    }];
    
    self.playerImageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.playerImageView.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
    self.playerImageView.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
}


#pragma mark - getter
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
    }
    return _backgroundImageView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage yjijk_imageNamed:@"yj_back"] forState:UIControlStateNormal];
        _backBtn.hidden = YES;
    }
    return _backBtn;
}

- (UIButton *)playerImageView {
    if (!_playerImageView) {
        _playerImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playerImageView setImage:[UIImage yjijk_imageNamed:@"yj_start_play"] forState:UIControlStateNormal];
        [_playerImageView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _playerImageView.titleLabel.font = [UIFont systemFontOfSize:16];
        _playerImageView.titleLabel.textAlignment = NSTextAlignmentCenter;
        _playerImageView.userInteractionEnabled = NO;
    }
    return _playerImageView;
}

@end
