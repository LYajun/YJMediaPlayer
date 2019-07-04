//
//  YJViewController.m
//  YJMediaPlayer
//
//  Created by lyj on 07/04/2019.
//  Copyright (c) 2019 lyj. All rights reserved.
//

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
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"google-help-vr" ofType:@"mp4"];
    
    //    model.videoURL = [NSURL fileURLWithPath:path];
    
//    model.isMute = YES;
    
    model.videoURL = [NSURL URLWithString:[@"http://192.168.3.158:10171//lgftp/zyk/xl/Speaking/10/Ordering food/Ordering food.mpg" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    self.player = [YJIJKVideoPlayer videoPlayerWithView:self.playerFatherView delegate:self playerModel:model];
    [self.player playVideo];
}

- (IBAction)stopPlayer:(UIButton *)sender {
        [self.player destroyVideo];
//    [self.player setisMute:NO];
}
- (IBAction)pausePlayer:(UIButton *)sender {
    [self.player pauseVideo];
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

@end
