#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "YJMediaPlayer.h"
#import "NSBundle+YJIJKPlayerView.h"
#import "UIButton+YJIJKPlayerRotation.h"
#import "UIColor+YJIJKPlayerView.h"
#import "UIImage+YJIJKPlayerView.h"
#import "UIView+YJIJKPlayerView.h"
#import "YJIJKLrcCell.h"
#import "YJIJKLrcView.h"
#import "YJIJKSrtModel.h"
#import "YJIJKMarqueeLabel.h"
#import "YJIJKPlayerModel.h"
#import "YJIJKPlayerStatusModel.h"
#import "YJIJKPlayerManager.h"
#import "YJIJKVideoPlayer.h"
#import "YJIJKBrightnessView.h"
#import "YJIJKCoverControlView.h"
#import "YJIJKLandScapeControlView.h"
#import "YJIJKLoadingView.h"
#import "YJIJKMaterialDesignSpinner.h"
#import "YJIJKPlayerControlView.h"
#import "YJIJKPortraitControlView.h"
#import "YJIJKVideoPlayerView.h"

FOUNDATION_EXPORT double YJMediaPlayerVersionNumber;
FOUNDATION_EXPORT const unsigned char YJMediaPlayerVersionString[];

