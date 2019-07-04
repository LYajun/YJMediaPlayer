//
//  UIViewController+YJIJKPlayerRotation.m
//  YJIJKPlayerViewDemo
//
//  Created by 刘亚军 on 2018/3/15.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "UIViewController+YJIJKPlayerRotation.h"

@implementation UIViewController (YJIJKPlayerRotation)
/**
 * 默认所有都不支持转屏,如需个别页面支持除竖屏外的其他方向，请在viewController重写下边这三个方法
 */
// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return NO;
}
// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}
@end
