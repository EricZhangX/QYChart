//
//  QYLineChartData.h
//  QYChart
//
//  Created by 张庆玉 on 2017/4/20.
//  Copyright © 2017年 张庆玉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QYLineChartData : NSObject

@property (nonatomic, strong) NSMutableArray<NSNumber *> *values;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat lineWidth;

- (instancetype)initWithValues:(NSArray<NSNumber *> *)values Color:(UIColor *)color LineWidth:(CGFloat)lineWidth;

@end
