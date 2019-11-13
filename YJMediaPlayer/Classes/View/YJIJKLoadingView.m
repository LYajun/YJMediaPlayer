//
//  YJIJKLoadingView.m
//  拉面视频Demo
//
//  Created by 刘亚军 on 2016/10/12.
//  Copyright © 2016年 lamiantv. All rights reserved.
//

#import "YJIJKLoadingView.h"
#import "YJIJKMaterialDesignSpinner.h"

#import <Masonry/Masonry.h>
#import "UIImage+YJIJKPlayerView.h"
#import "UIColor+YJIJKPlayerView.h"

@interface YJIJKLoadingView ()
/** 返回按钮 */
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) YJIJKMaterialDesignSpinner *activity;
@end

@implementation YJIJKLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backBtn];

        [self addSubview:self.activity];
        
        [self makeSubViewsConstraints];
        
        self.backgroundColor = [UIColor blackColor];
        
        // 拦截手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction)];
        [doubleTap setNumberOfTapsRequired:2];
        [self addGestureRecognizer:doubleTap];
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection)];
        [self addGestureRecognizer:panRecognizer];
        
        [self.activity startAnimating];
        [self makeSubViewsAction];
    }
    return self;
}

- (void)makeSubViewsAction {
    [self.backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Action
- (void)tapAction {}
- (void)doubleTapAction {}
- (void)panDirection {}
- (void)backBtnClickAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(loadingViewBackButtonClick)]) {
        [self.delegate loadingViewBackButtonClick];
    }
}

#pragma mark - 添加子控件约束
- (void)makeSubViewsConstraints {
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.left.equalTo(self).offset(6);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    

    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.with.height.mas_equalTo(IsIPad ? 50 : 30);
    }];
}


#pragma mark - getter
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage yjijk_imageNamed:@"yj_back"] forState:UIControlStateNormal];
        _backBtn.hidden = YES;
    }
    return _backBtn;
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
@end
