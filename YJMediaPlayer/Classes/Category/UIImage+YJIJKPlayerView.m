//
//  UIImage+YJIJKPlayerView.m
//  YJIJKPlayerViewDemo
//
//  Created by 刘亚军 on 2019/1/10.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "UIImage+YJIJKPlayerView.h"
#import "NSBundle+YJIJKPlayerView.h"

@implementation UIImage (YJIJKPlayerView)
+ (UIImage *)yjijk_imageNamed:(NSString *)name{
    return [self yjijk_imageNamed:name atDir:nil];
}
+ (UIImage *)yjijk_imageNamed:(NSString *)name atDir:(NSString *)dir{
    NSString *namePath = name;
    if (dir && dir.length > 0) {
        namePath = [dir stringByAppendingPathComponent:namePath];
    }
    return [UIImage imageNamed:[NSBundle yjijk_playerViewBundlePathWithName:namePath]];
}
@end
