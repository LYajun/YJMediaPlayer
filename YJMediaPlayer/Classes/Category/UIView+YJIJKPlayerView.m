//
//  UIView+YJIJKPlayerView.m
//  YJIJKPlayerViewDemo
//
//  Created by 刘亚军 on 2019/1/10.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "UIView+YJIJKPlayerView.h"
#import <objc/runtime.h>

@implementation UIView (YJIJKPlayerView)
+ (Class)layerClass {
    return [CAGradientLayer class];
}
+ (UIView *)yjijk_gradientViewWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    UIView *view = [[self alloc] init];
    [view yjijk_setGradientBackgroundWithColors:colors locations:locations startPoint:startPoint endPoint:endPoint];
    return view;
}
- (void)yjijk_setGradientBackgroundWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    NSMutableArray *colorsM = [NSMutableArray array];
    for (UIColor *color in colors) {
        [colorsM addObject:(__bridge id)color.CGColor];
    }
    self.colors = [colorsM copy];
    self.locations = locations;
    self.startPoint = startPoint;
    self.endPoint = endPoint;
}

- (void)lgijk_clipLayerWithRadius:(CGFloat)r width:(CGFloat)w color:(UIColor *)color{
    self.layer.cornerRadius = r;
    self.layer.borderWidth = w;
    self.layer.borderColor = color.CGColor;
    self.layer.masksToBounds = YES;
}
- (void)yjijk_clipLayerWithRadius:(CGFloat)r width:(CGFloat)w color:(UIColor *)color{
    self.layer.cornerRadius = r;
    self.layer.borderWidth = w;
    self.layer.borderColor = color.CGColor;
    self.layer.masksToBounds = YES;
}

#pragma mark - getter
- (NSArray *)colors {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setColors:(NSArray *)colors {
    objc_setAssociatedObject(self, @selector(colors), colors, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setColors:self.colors];
    }
}

- (NSArray<NSNumber *> *)locations {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLocations:(NSArray<NSNumber *> *)locations {
    objc_setAssociatedObject(self, @selector(locations), locations, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setLocations:self.locations];
    }
}

- (CGPoint)startPoint {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setStartPoint:(CGPoint)startPoint {
    objc_setAssociatedObject(self, @selector(startPoint), [NSValue valueWithCGPoint:startPoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setStartPoint:self.startPoint];
    }
}

- (CGPoint)endPoint {
    return [objc_getAssociatedObject(self, _cmd) CGPointValue];
}

- (void)setEndPoint:(CGPoint)endPoint {
    objc_setAssociatedObject(self, @selector(endPoint), [NSValue valueWithCGPoint:endPoint], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self.layer isKindOfClass:[CAGradientLayer class]]) {
        [((CAGradientLayer *)self.layer) setEndPoint:self.endPoint];
    }
}

@end

@implementation UILabel (YJIJKPlayerView)

+ (Class)layerClass {
    return [CAGradientLayer class];
}

@end
