//
//  YJIJKLoadingView.h
//  拉面视频Demo
//
//  Created by 刘亚军 on 2016/10/12.
//  Copyright © 2016年 lamiantv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YJIJKLoadingViewDelegate <NSObject>

/** 返回按钮被点击 */
- (void)loadingViewBackButtonClick;
@end

@interface YJIJKLoadingView : UIView
@property (nonatomic, weak) id<YJIJKLoadingViewDelegate> delegate;
@end
