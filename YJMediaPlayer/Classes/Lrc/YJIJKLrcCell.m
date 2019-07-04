//
//  YJIJKLrcCell.m
//  
//
//  Created by 刘亚军 on 2018/12/1.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJIJKLrcCell.h"
#import <Masonry/Masonry.h>

@interface YJIJKLrcCell ()
@property (nonatomic,strong) UILabel *contentL;
@end
@implementation YJIJKLrcCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.contentL];
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(3);
        make.left.equalTo(self.contentView).offset(10);
        make.center.equalTo(self.contentView);
        make.height.mas_greaterThanOrEqualTo(30);
    }];
}
- (void)setLrcText:(NSString *)lrcText{
    _lrcText = lrcText;
    self.contentL.text = lrcText;
}
- (void)setChoiced:(BOOL)choiced{
    _choiced = choiced;
    if (choiced) {
        self.contentL.textColor = [UIColor yellowColor];
    }else{
        self.contentL.textColor = [UIColor whiteColor];
    }
}
- (UILabel *)contentL{
    if (!_contentL) {
        _contentL = [UILabel new];
        _contentL.textAlignment = NSTextAlignmentCenter;
        _contentL.textColor = [UIColor whiteColor];
        _contentL.font = [UIFont systemFontOfSize:15];
        _contentL.numberOfLines = 0;
    }
    return _contentL;
}
@end
