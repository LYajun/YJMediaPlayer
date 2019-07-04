//
//  UIButton+YJIJKPlayerRotation.h
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (YJIJKPlayerRotation)
/** 设置按钮额外热区 */
@property (nonatomic, assign) UIEdgeInsets yjijk_touchAreaInsets;

@end

NS_ASSUME_NONNULL_END
