//
//  YJIJKPlayerModel.h
//  lamiantv
//
//  Created by 刘亚军 on 2016/12/2.
//  Copyright © 2016年 AiPai. All rights reserved.
//  所播放视频的模型

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class YJIJKSrtModel;
@interface YJIJKPlayerModel : NSObject
/** 视频标题 */
@property (nonatomic, copy  ) NSString     *title;
/** 视频URL */
@property (nonatomic, strong) NSURL        *videoURL;
/** 视频封面本地图片 */
@property (nonatomic, strong) UIImage      *placeholderImage;
/**
 * 视频封面网络图片url
 * 如果和本地图片同时设置，则忽略本地图片，显示网络图片
 */
@property (nonatomic, copy  ) NSString     *placeholderImageURLString;
/** 视频分辨率 */
@property (nonatomic, strong) NSDictionary *resolutionDic;

/** 视频的ID */
@property (nonatomic, assign) NSInteger    videoId;
/** 字幕 */
@property (nonatomic,strong) YJIJKSrtModel *srtModel;
@property (nonatomic,strong) NSArray<YJIJKSrtModel *> *srtModelArray;
/** 是否显示纯音乐背景 */
@property (nonatomic,assign) BOOL isShowVoiceBgImg;

/** 竖屏字幕不可见性，默认可见 */
@property (nonatomic,assign) BOOL portraitSrtInvisible;

/** 是否静音 */
@property (nonatomic, assign) BOOL isMute;
/** 从xx秒开始播放视频 */
@property (nonatomic, assign) NSInteger seekTime;

/** 播放完成是否显示重播按钮 */
@property (nonatomic,assign) BOOL closeRepeatBtn;
@end
