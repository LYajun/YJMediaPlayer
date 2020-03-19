//
//  UIView+YJIJKPlayerView.h
//  YJIJKPlayerViewDemo
//
//  Created by 刘亚军 on 2019/1/10.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YJIJKPlayerView)
@property(nullable, copy) NSArray *colors;
@property(nullable, copy) NSArray<NSNumber *> *locations;
@property CGPoint startPoint;
@property CGPoint endPoint;
+ (UIView *_Nullable)yjijk_gradientViewWithColors:(NSArray<UIColor *> *_Nullable)colors
                                      locations:(NSArray<NSNumber *> *_Nullable)locations
                                     startPoint:(CGPoint)startPoint
                                       endPoint:(CGPoint)endPoint;

- (void)yjijk_setGradientBackgroundWithColors:(NSArray<UIColor *> *_Nullable)colors
                                  locations:(NSArray<NSNumber *> *_Nullable)locations
                                 startPoint:(CGPoint)startPoint
                                   endPoint:(CGPoint)endPoint;

/** 倒角 */
- (void)yjijk_clipLayerWithRadius:(CGFloat)r
                          width:(CGFloat)w
                          color:(UIColor *)color;
- (BOOL)yjijk_isIPhoneX;
- (CGFloat)yjijk_stateBarSpace;
- (CGFloat)yj_tabBarSpace;
@end
