
//
//  YJIJKMarqueeLabel.h
//  LGMultimediaFramework
//
//  Created by 刘亚军 on 2019/3/4.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YJIJKMarqueeLabelType) {
    YJIJKMarqueeLabelTypeLeft = 0,//向左边滚动
    YJIJKMarqueeLabelTypeLeftRight = 1,//先向左边，再向右边滚动
};

@interface YJIJKMarqueeLabel : UILabel

@property(nonatomic,assign) YJIJKMarqueeLabelType marqueeLabelType;
@property(nonatomic,assign) CGFloat speed;//速度
@property(nonatomic,assign) CGFloat secondLabelInterval;
@property(nonatomic,assign) NSTimeInterval stopTime;//滚到顶的停止时间
- (void)invalidateTimer;
@end

NS_ASSUME_NONNULL_END
