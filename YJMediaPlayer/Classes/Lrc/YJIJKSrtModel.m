//
//  YJIJKSrtModel.m
//
//
//  Created by 刘亚军 on 2018/11/30.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJIJKSrtModel.h"
#import <MJExtension/MJExtension.h>

@implementation YJIJKSrtInfoModel

@end
@implementation YJIJKSrtModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"srtList":[YJIJKSrtInfoModel class]};
}
- (instancetype)initWithDictionary:(NSDictionary *)aDictionary {
    self = [self.class mj_objectWithKeyValues:aDictionary];
    return self;
}

- (instancetype)initWithJSONString:(NSString *)aJSONString {
    self = [self.class mj_objectWithKeyValues:aJSONString];
    return self;
}
@end
