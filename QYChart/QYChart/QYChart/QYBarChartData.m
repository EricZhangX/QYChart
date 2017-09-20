//
//  QYBarChartData.m
//  QYChart
//
//  Created by 张庆玉 on 2017/4/19.
//  Copyright © 2017年 张庆玉. All rights reserved.
//

#import "QYBarChartData.h"

@implementation QYBarChartData

- (instancetype)initWithValue:(CGFloat)value Width:(CGFloat)width Color:(NSArray *)colors {
    self = [super init];
    if (self) {
        self.value = value;
//        NSLog(@"value = %@ -- self.value = %@",@(value),@(self.value));
        self.barWidth = width;
        self.colors = colors;
    }
    return self;
}
@end
