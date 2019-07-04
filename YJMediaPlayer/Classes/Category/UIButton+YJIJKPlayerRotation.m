//
//  UIButton+YJIJKPlayerRotation.m
//  YJExtensionsDemo
//
//  Created by 刘亚军 on 2019/3/14.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "UIButton+YJIJKPlayerRotation.h"
#import <objc/runtime.h>
@interface UIButton ()

@end
@implementation UIButton (YJIJKPlayerRotation)
- (UIEdgeInsets)yjijk_touchAreaInsets{
    return [objc_getAssociatedObject(self, @selector(yjijk_touchAreaInsets)) UIEdgeInsetsValue];
}

- (void)setYjijk_touchAreaInsets:(UIEdgeInsets)touchAreaInsets{
    NSValue *value = [NSValue valueWithUIEdgeInsets:touchAreaInsets];
    objc_setAssociatedObject(self, @selector(yjijk_touchAreaInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    UIEdgeInsets touchAreaInsets = self.yjijk_touchAreaInsets;
    CGRect bounds = self.bounds;
    bounds = CGRectMake(bounds.origin.x - touchAreaInsets.left,
                        bounds.origin.y - touchAreaInsets.top,
                        bounds.size.width + touchAreaInsets.left + touchAreaInsets.right,
                        bounds.size.height + touchAreaInsets.top + touchAreaInsets.bottom);
    return CGRectContainsPoint(bounds, point);
}

@end
