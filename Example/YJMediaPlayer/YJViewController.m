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

@interface YJViewController ()<YJIJKVideoPlayerDelegate>
@property (nonatomic, strong) YJIJKVideoPlayer *player;

@property (weak, nonatomic) IBOutlet UIView *playerFatherView;


@end

@implementation YJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    YJIJKPlayerModel *model = [[YJIJKPlayerModel alloc] init];
    model.title = @"测试视频";
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"google-help-vr" ofType:@"mp4"];
    
//        model.videoURL = [NSURL fileURLWithPath:path];
    
//    model.isMute = YES;
//    model.isVipMode = NO;
    model.seekTime = 30;
    model.seekEndTime = 100;
//    model.closeRepeatBtn = YES;

    model.videoURL = [NSURL URLWithString:[@"http://192.168.129.129:10132/lgftp/LBD_TeachProgram/y129/491cf0fd-8b42-4e3b-b4f2-968307a00f5f/TeachClassProgram/4895fca1-9583-4a07-b0cf-a257318823b8/54m.mp4" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    self.player = [YJIJKVideoPlayer videoPlayerWithView:self.playerFatherView delegate:self playerModel:model];
    [self.player playVideo];
}

- (IBAction)stopPlayer:(UIButton *)sender {
        [self.player destroyVideo];
//    [self.player setisMute:NO];
}
- (IBAction)pausePlayer:(UIButton *)sender {
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
@end
