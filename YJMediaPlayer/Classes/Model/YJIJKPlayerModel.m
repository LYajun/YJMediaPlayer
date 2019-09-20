//
//  YJIJKPlayerModel.m
//  lamiantv
//
//  Created by 刘亚军 on 2016/12/2.
//  Copyright © 2016年 AiPai. All rights reserved.
//

#import "YJIJKPlayerModel.h"
#import "UIImage+YJIJKPlayerView.h"

@implementation YJIJKPlayerModel
- (instancetype)init{
    if (self = [super init]) {
        _isVipMode = YES;
    }
    return self;
}
- (UIImage *)placeholderImage
{
    if (!_placeholderImage) {
        _placeholderImage = [UIImage yjijk_imageNamed:@"placeholderImage"];
//        _placeholderImage = [self createImageWithColor:[UIColor blackColor]];
    }
    return _placeholderImage;
}

#pragma mark - other
/**
 *  通过颜色来生成一个纯色图片
 */
- (UIImage *)createImageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContext(CGSizeMake(1.0f, 1.0f));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
