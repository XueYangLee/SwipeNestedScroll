//
//  NestedTableView.m
//  SwipeNestedScroll
//
//  Created by Singularity on 2020/8/5.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import "NestedTableView.h"

@implementation NestedTableView

/** 核心 设置内边距外区域的点击不响应 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (point.y < 0) {
        return nil;
    }else {
        return [super hitTest:point withEvent:event];
    }
}

@end
