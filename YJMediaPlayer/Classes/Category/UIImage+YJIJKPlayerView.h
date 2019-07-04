//
//  UIImage+YJIJKPlayerView.h
//  YJIJKPlayerViewDemo
//
//  Created by 刘亚军 on 2019/1/10.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YJIJKPlayerView)
+ (UIImage *)yjijk_imageNamed:(NSString *)name;
+ (UIImage *)yjijk_imageNamed:(NSString *)name atDir:(NSString *)dir;
@end
