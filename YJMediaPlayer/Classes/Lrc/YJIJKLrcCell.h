//
//  YJIJKLrcCell.h
//
//
//  Created by 刘亚军 on 2018/12/1.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJIJKLrcCell : UITableViewCell
/** 字幕 */
@property (nonatomic,copy) NSString *lrcText;
/** 是否选中 */
@property (nonatomic,assign) BOOL choiced;
@end
