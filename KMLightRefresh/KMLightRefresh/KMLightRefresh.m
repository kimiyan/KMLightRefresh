//
//  KMLightRefresh.m
//  KMLightRefresh
//
//  Created by KIMI on 16/11/12.
//  Copyright © 2016年 KIMI. All rights reserved.
//

#import "KMLightRefresh.h"
//记录当前刷新状态
typedef enum NSInteger {
    //下拉刷新
    KMRefreshStateNormal,
    //松手就刷新
    KMRefreshStatePulling,
    //正在刷新
    KMRefreshStateRefrsh
}KMRefrshState;
@interface KMLightRefresh ()
//当前刷新状态
@property(nonatomic,assign)KMRefrshState refreshState;
//内容Label
@property(nonatomic,weak)UILabel *textLabel;
//刷新图片
@property(nonatomic,weak)UIImageView *refreshImageView;
@end

@implementation KMLightRefresh

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [label setTextColor:[UIColor lightGrayColor]];
    label.text = @"下拉刷新";
    
    
}

@end
