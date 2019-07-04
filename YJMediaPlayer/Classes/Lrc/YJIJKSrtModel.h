//
//  YJIJKSrtModel.h
//  
//
//  Created by 刘亚军 on 2018/11/30.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface YJIJKSrtInfoModel : NSObject
/** 开始时间点 */
@property (nonatomic,assign) CGFloat beginTime;
/** 结束时间点 */
@property (nonatomic,assign) CGFloat endTime;
/** 字幕 */
@property (nonatomic,copy) NSString *subtitles;
@end
@interface YJIJKSrtModel : NSObject
/** 字幕类型
 0:lrc
 1:Srt
 */
@property (nonatomic,assign) NSInteger subTitleType;
@property (nonatomic,strong) NSArray<YJIJKSrtInfoModel *> *srtList;

/** 用字典初始化（MJExtension） */
- (instancetype)initWithDictionary:(NSDictionary *)aDictionary;

/** 用JSONString初始化 */
- (instancetype)initWithJSONString:(NSString *)aJSONString;
@end
