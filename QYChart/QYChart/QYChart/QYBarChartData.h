//
//  QYBarChartData.h
//  QYChart
//
//  Created by 张庆玉 on 2017/4/19.
//  Copyright © 2017年 张庆玉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QYBarChartData : NSObject

//数据范围值
@property (nonatomic, assign) CGFloat value;
//宽度
@property (nonatomic, assign) CGFloat barWidth;
//颜色
@property (nonatomic, strong) UIColor *color;

- (instancetype)initWithValue:(CGFloat)value Width:(CGFloat)width Color:(UIColor *)color;

@end
