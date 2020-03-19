//
//  YJViewController.m
//  YJMediaPlayer
//
//  Created by lyj on 07/04/2019.
//  Copyright (c) 2019 lyj. All rights reserved.
// http://192.168.129.129:10132/lgftp/LBD_TeachProgram/y129/491cf0fd-8b42-4e3b-b4f2-968307a00f5f/TeachClassProgram/4895fca1-9583-4a07-b0cf-a257318823b8/54m.mp4
// http://192.168.129.129:10104//lgRs/2d825d6f4cd744368daea2b146c97fcc/47fb4b1f8c114365ad61f6d727253e35.mp4
#import "YJViewController.h"
#import <YJMediaPlayer/YJMediaPlayer.h>
#import <Masonry/Masonry.h>

@interface YJViewController ()<YJIJKVideoPlayerDelegate>
@property (nonatomic, strong) YJIJKVideoPlayer *player;

@property (strong, nonatomic) UIView *playerFatherView;


@end

@implementation YJViewController

- (UIView *)playerFatherView{
    if (!_playerFatherView) {
        _playerFatherView = [UIView new];
    }
    return _playerFatherView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    
    
    [self.view addSubview:self.playerFatherView];
    [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.left.top.equalTo(self.view);
        make.height.equalTo(self.playerFatherView.mas_width).multipliedBy(9.0/16);
    }];
    
    YJIJKPlayerModel *model = [[YJIJKPlayerModel alloc] init];
    model.title = @"测试stringByAddingPercentEncodingWithAllowedCharacters视频靠的就是发的复合大师看发送到反馈蓝色的就反馈蓝色的建峰";
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"google-help-vr" ofType:@"mp4"];
    
//        model.videoURL = [NSURL fileURLWithPath:path];
    
//    model.isMute = YES;
    model.isVipMode = NO;
//    model.seekTime = 20;
    model.vipTime = 15;
    model.seekStartTime = 0;
    model.seekEndTime = 56;
//    model.closeRepeatBtn = YES;

    model.videoURL = [NSURL URLWithString:[@"http://192.168.129.129:10104//lgRs/7a8931d8ef0c4c6bbac9e26c04bf50d5/ac7f89a9a7ee4107a4282c325220be5f.mp4" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    self.player = [YJIJKVideoPlayer videoPlayerWithView:self.playerFatherView delegate:self playerModel:model];
    [self.player playVideo];
}

- (void)stopPlayer:(UIButton *)sender {
        [self.player destroyVideo];
//    [self.player setisMute:NO];
}
- (void)pausePlayer:(UIButton *)sender {
//    [self.player pauseVideo];
    [self.player seekToTime:30];
}


#pragma YJIJKVideoPlayerDelegate
/** 控制层封面点击事件的回调 */
- (void)controlViewTapAction {
    if (_player) {
        [self.player autoPlayTheVideo];
    }
}
- (void)changePlayProgress:(double)progress second:(CGFloat)second{
    NSLog(@"播放进度: %f",second);
}
- (void)playerDidEndAction{
    NSLog(@"播放完成");
}


- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
@end
