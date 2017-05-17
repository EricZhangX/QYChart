//
//  QYLineChartData.m
//  QYChart
//
//  Created by 张庆玉 on 2017/4/20.
//  Copyright © 2017年 张庆玉. All rights reserved.
//

#import "QYLineChartData.h"

@implementation QYLineChartData

- (instancetype)initWithValues:(NSArray<NSNumber *> *)values Color:(UIColor *)color LineWidth:(CGFloat)lineWidth {
    self = [super init];
    if (self) {
        self.values = [values mutableCopy];
        self.color = color;
        self.lineWidth = lineWidth;
    }
    return self;
}
@end
