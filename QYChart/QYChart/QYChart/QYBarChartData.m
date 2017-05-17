//
//  QYBarChartData.m
//  QYChart
//
//  Created by 张庆玉 on 2017/4/19.
//  Copyright © 2017年 张庆玉. All rights reserved.
//

#import "QYBarChartData.h"

@implementation QYBarChartData

- (instancetype)initWithValue:(CGFloat)value Width:(CGFloat)width Color:(UIColor *)color {
    self = [super init];
    if (self) {
        self.value = value;
        self.barWidth = width;
        self.color = color;
    }
    return self;
}
@end
