//
//  UIColor+YJIJKPlayerView.h
//
//
//  Created by 刘亚军 on 2017/8/24.
//  Copyright © 2017年 lange. All rights reserved.
//

#import <UIKit/UIKit.h>

#define YJIJKPlayView_ColorWithHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define IsIPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface UIColor (YJIJKPlayerView)

+ (UIColor *)yjijk_colorwithHexString:(NSString *)color;
+ (UIColor *)yjijk_colorWithHex:(NSInteger)hexValue;
+ (UIColor*)yjijk_colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
@end
