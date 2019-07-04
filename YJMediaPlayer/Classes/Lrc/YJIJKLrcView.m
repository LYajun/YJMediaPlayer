//
//  YJIJKLrcView.m
//
//
//  Created by 刘亚军 on 2018/12/1.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "YJIJKLrcView.h"
#import "YJIJKLrcCell.h"
#import "YJIJKSrtModel.h"
#import <Masonry/Masonry.h>

@interface YJIJKLrcView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger currentIndex;
@end
@implementation YJIJKLrcView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}
- (void)layoutUI{
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
- (void)setSrtModel:(YJIJKSrtModel *)srtModel{
    _srtModel = srtModel;
    [self.tableView reloadData];
}
- (void)setCurrentTime:(CGFloat)currentTime{
    _currentTime = currentTime;
    YJIJKSrtInfoModel *firstInfo = self.srtModel.srtList.firstObject;
    if (currentTime < firstInfo.beginTime) {
         [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }else{
        NSIndexPath *lastIndexP = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
        YJIJKLrcCell *lastCell = [self.tableView cellForRowAtIndexPath:lastIndexP];
        lastCell.choiced = NO;
        for (int i = 0; i < self.srtModel.srtList.count; i++) {
            if (i == self.srtModel.srtList.count-1) {
                self.currentIndex = i;
            }else{
                YJIJKSrtInfoModel *currentInfo = self.srtModel.srtList[i];
                YJIJKSrtInfoModel *nextInfo = self.srtModel.srtList[i+1];
                if (currentTime >= currentInfo.beginTime &&
                    currentTime < nextInfo.beginTime) {
                    self.currentIndex = i;
                    break;
                }
            }
        }
        NSIndexPath *currentIndexP = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
        YJIJKLrcCell *currentCell = [self.tableView cellForRowAtIndexPath:currentIndexP];
        currentCell.choiced = YES;
        [self.tableView scrollToRowAtIndexPath:currentIndexP atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.srtModel.srtList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YJIJKLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YJIJKLrcCell class]) forIndexPath:indexPath];
    YJIJKSrtInfoModel *infoModel = self.srtModel.srtList[indexPath.row];
    cell.lrcText = infoModel.subtitles;
    if (indexPath.row == self.currentIndex) {
        cell.choiced = YES;
    }else{
        cell.choiced = NO;
    }
    return cell;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 30;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[YJIJKLrcCell class] forCellReuseIdentifier:NSStringFromClass([YJIJKLrcCell class])];
    }
    return _tableView;
}
@end
