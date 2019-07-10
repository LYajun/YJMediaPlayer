//
//  UIButton+YJIJKPlayerRotation.h
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, YJIJKImagePosition) {
    YJIJKImagePositionLeft = 0,              //图片在左，文字在右，默认
    YJIJKImagePositionRight = 1,             //图片在右，文字在左
    YJIJKImagePositionTop = 2,               //图片在上，文字在下
    YJIJKImagePositionBottom = 3,            //图片在下，文字在上
};

@interface UIButton (YJIJKPlayerRotation)
/** 设置按钮额外热区 */
@property (nonatomic, assign) UIEdgeInsets yjijk_touchAreaInsets;
- (void)yjijk_setImagePosition:(YJIJKImagePosition)postion spacing:(CGFloat)spacing;
@end

NS_ASSUME_NONNULL_END
