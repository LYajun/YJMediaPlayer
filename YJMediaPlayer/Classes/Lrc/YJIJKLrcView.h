//
//  YJIJKLrcView.h
//
//
//  Created by 刘亚军 on 2018/12/1.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJIJKSrtModel;
@interface YJIJKLrcView : UIView
/** 字幕 */
@property (nonatomic,strong) YJIJKSrtModel *srtModel;

@property (nonatomic,assign) CGFloat currentTime;
/** 字幕字体大小 */
@property (nonatomic, assign) CGFloat fontSize;
@end
