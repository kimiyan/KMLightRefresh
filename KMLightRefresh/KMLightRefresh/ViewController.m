//
//  ViewController.m
//  KMLightRefresh
//
//  Created by KIMI on 16/11/12.
//  Copyright © 2016年 KIMI. All rights reserved.
//

#import "ViewController.h"
#import "KMLightRefresh.h"
static NSString *cellID = @"cellID";
@interface ViewController ()
@end

@implementation ViewController {
    KMLightRefresh *_refresh;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupRefresh];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

- (void)setupRefresh {
    
    _refresh = [[KMLightRefresh alloc]initWithHeight:50];
    
    [self.view addSubview:_refresh];
    
    [_refresh addTarget:self action:@selector(refreshing) forControlEvents:UIControlEventValueChanged];
}
- (void)refreshing {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_refresh endRefresh];
        
    });
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 15;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.text = @"KMLightRefresh";
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
