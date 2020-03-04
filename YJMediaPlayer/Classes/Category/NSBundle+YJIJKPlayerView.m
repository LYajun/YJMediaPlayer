//
//  NSBundle+YJIJKPlayerView.m
//
//
//  Created by 刘亚军 on 2019/1/10.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "NSBundle+YJIJKPlayerView.h"

@interface YJIJKExtModel : NSObject
@end
@implementation YJIJKExtModel
@end

@implementation NSBundle (YJIJKPlayerView)
+ (instancetype)yjijk_playerViewBundle{
    static NSBundle *dictionaryBundle = nil;
    if (!dictionaryBundle) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        dictionaryBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[YJIJKExtModel class]] pathForResource:@"YJMediaPlayer" ofType:@"bundle"]];
    }
    return dictionaryBundle;
}
+ (NSString *)yjijk_playerViewBundlePathWithName:(NSString *)name{
     return [[[NSBundle yjijk_playerViewBundle] resourcePath] stringByAppendingPathComponent:name];
}
@end
