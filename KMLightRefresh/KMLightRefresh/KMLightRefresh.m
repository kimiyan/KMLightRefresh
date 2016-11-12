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
}KMRefreshState;
@interface KMLightRefresh ()
//当前刷新状态
@property(nonatomic,assign)KMRefreshState refreshState;
//上一次刷新状态
@property(nonatomic,assign)KMRefreshState lastReFreshStre;
//内容Label
@property(nonatomic,weak)UILabel *textLabel;
//刷新图片
@property(nonatomic,weak)UIImageView *refreshImageView;
//常态视图
@property(nonatomic,weak)UIImageView *normalImageView;
@end

@implementation KMLightRefresh {
    
    CGFloat _controlWidth;
    CGFloat _controlHeight;
    //当前视图
    UIScrollView *_currentView;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (void)setRefreshState:(KMRefreshState)refreshState {
    
    _refreshState = refreshState;
    switch (refreshState) {
        case KMRefreshStateNormal:
            NSLog(@"normal");
            if (_lastReFreshStre == KMRefreshStateRefrsh) {
                
            UIEdgeInsets edge = UIEdgeInsetsMake(_currentView.contentInset.top - _controlHeight, 0, 0, 0);
            [UIView animateWithDuration:1 animations:^{
                    
                _currentView.contentInset = edge;
            }];
                
            }
            _refreshImageView.hidden = YES;
            _normalImageView.hidden = NO;
            _textLabel.text = @"下拉刷新";
            break;
        case KMRefreshStatePulling:
            NSLog(@"pulling");
            _normalImageView.hidden = YES;
            _refreshImageView.hidden = NO;
            _textLabel.text = @"松手刷新";
            break;
        case KMRefreshStateRefrsh:
            NSLog(@"refreshing");
            UIEdgeInsets edge = UIEdgeInsetsMake(_currentView.contentInset.top + _controlHeight, 0, 0, 0);
            [UIView animateWithDuration:0.25 animations:^{
                
                _currentView.contentInset = edge;
            }];
            
            _normalImageView.hidden = YES;
            _refreshImageView.hidden = NO;
            _textLabel.text = @"正在刷新";
            
            //发送值改变事件
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            break;
    }
}
//结束刷新
- (void)endRefresh {
    self.lastReFreshStre = KMRefreshStateRefrsh;
    self.refreshState = KMRefreshStateNormal;
}

- (instancetype)initWithHeight: (CGFloat) height {
    
    _controlWidth = [UIScreen mainScreen].bounds.size.width;
    _controlHeight = height;
    self = [super init];
    if (self) {
        _refreshState = KMRefreshStateNormal;
        [self setupUI];
    }
    return self;
}

//监听父控件滚动
- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    UIScrollView *view = (UIScrollView *)newSuperview;
    self.frame = CGRectMake(0, - _controlHeight, _controlWidth , _controlHeight);
    //kvo 监听自身的contentOffset变化(新值)
    [view addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    _currentView = view;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    CGFloat contentOffsetY = _currentView.contentOffset.y;
    //临界点
    CGFloat maxY = - (_currentView.contentInset.top + _controlHeight);
        //判断是否是拖拽
    if ([_currentView isDragging]) {
        
        if (contentOffsetY < maxY &&  _refreshState == KMRefreshStateNormal) {
            NSLog(@"松手就刷新");
            self.refreshState = KMRefreshStatePulling;
        }else if (contentOffsetY >= maxY && _refreshState == KMRefreshStatePulling) {
  
            self.refreshState = KMRefreshStateNormal;
        }
    }else {
        if (_refreshState == KMRefreshStatePulling) {

            self.refreshState = KMRefreshStateRefrsh;
        }
    }

}

- (void)setupUI {
    
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [label setTextColor:[UIColor lightGrayColor]];
    label.text = @"下拉刷新";
    
    
    NSMutableArray *imgArr = [NSMutableArray array];
    for (NSInteger i = 0; i < 6; i ++) {
        NSString *name = [NSString stringWithFormat:@"0%zd.png",i + 1];
        
        NSURL *url = [[NSBundle mainBundle]URLForResource:name withExtension:nil subdirectory:@"image.bundle"];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        UIImage *img = [UIImage imageWithData:data];
        
        [imgArr addObject:img];
    }
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage animatedImageWithImages:imgArr duration:1]];
    

    
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"normal.png" withExtension:nil subdirectory:@"image.bundle"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    UIImage *normalImg = [UIImage imageWithData:data];
    UIImageView *normalImageView = [[UIImageView alloc]initWithImage:normalImg];
    
    
    _textLabel = label;
    _refreshImageView = imageView;
    _normalImageView = normalImageView;
    [self addSubview:label];
    [self addSubview:imageView];
    [self addSubview:normalImageView];
    
    //关闭控件的自动布局
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _refreshImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _normalImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //设置约束
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_refreshImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_textLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:-10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_refreshImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_textLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_refreshImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:20]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_refreshImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:20]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_normalImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_refreshImageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_normalImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_refreshImageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_normalImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_refreshImageView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_normalImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_refreshImageView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
}

@end
