//
//  YJIJKCoverView.h
//  拉面视频Demo
//
//  Created by 刘亚军 on 16/9/26.
//  Copyright © 2016年 lamiantv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YJIJKCoverControlViewDelegate <NSObject>

/** 返回按钮被点击 */
- (void)coverControlViewBackButtonClick;
/** 封面图片Tap事件 */
- (void)coverControlViewBackgroundImageViewTapAction;
@end

@interface YJIJKCoverControlView : UIView
@property (nonatomic, weak) id<YJIJKCoverControlViewDelegate> delegate;
/** 更新封面图片 */
- (void)syncCoverImageViewWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage;
@end
