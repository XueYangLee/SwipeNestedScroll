//
//  ViewController.m
//  SwipeNestedScroll
//
//  Created by Singularity on 2020/8/5.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import "ViewController.h"
#import "NestedScrollViewController.h"
#import "NestedScrollIdleViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cid"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cid"];
    }
    cell.textLabel.text=(indexPath.row==0)?@"仿淘宝物流":@"仿高德地图（定点停顿）";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        NestedScrollViewController *logistics=[NestedScrollViewController new];
        logistics.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:logistics animated:YES completion:nil];
    }else{
        NestedScrollIdleViewController *map=[NestedScrollIdleViewController new];
        map.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:map animated:YES completion:nil];
    }
}



@end
