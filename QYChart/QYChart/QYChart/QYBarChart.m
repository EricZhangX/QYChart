//
//  QYBarChart.m
//  QYChart
//
//  Created by 张庆玉 on 2017/4/19.
//  Copyright © 2017年 张庆玉. All rights reserved.
//

#import "QYBarChart.h"



@interface QYBarChart ()

@end

@implementation QYBarChart


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.chartData && self.chartData.count) {
        //[self drawBarWithChartData:self.chartData];
        [self drawChartWithData:self.chartData];
    }
}

- (void)drawChartWithData:(NSArray *)datas {
    NSInteger count = datas.count > self.xAxisTitles.count ? datas.count : self.xAxisTitles.count;

    for (int i = 0; i < count; i++) {
        NSArray *barDatas = datas[i];
        //柱状图x轴定位
        CGFloat xPosition = chartWidth * (i+1)/(count + 1);
        //柱状图y轴定位
        CGFloat currentValue = 0.f;
        for (int j = 0; j < barDatas.count; j++) {
            QYBarChartData *barData = barDatas[j];
            
            CGFloat yValue = currentValue + barData.value;
            CGFloat yStartPosition = chartHeight * (1.f -(currentValue - self.yAxisRange.location) / self.yAxisRange.length);
            CGFloat yEndPosition = chartHeight * (1.f -(yValue - self.yAxisRange.location) / self.yAxisRange.length);
            currentValue += barData.value;
            
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.colors = @[(__bridge id)[barData.colors firstObject].CGColor, (__bridge id)[barData.colors lastObject].CGColor];
            
//            gradientLayer.locations = @[@((offSetY + ChartLeftPadding + xPosition - 0.5 * barData.barWidth)/ chartWidth), @((ChartTopPadding + yEndPosition + 0.5 * barData.barWidth)/chartHeight)];
            
//            gradientLayer.startPoint = CGPointMake((offSetY + ChartLeftPadding + xPosition) / chartWidth, (ChartTopPadding + yStartPosition) / chartHeight);
//            gradientLayer.endPoint = CGPointMake((offSetY + ChartLeftPadding + xPosition) / chartWidth, (ChartTopPadding + yEndPosition) / chartHeight);
            gradientLayer.locations = @[@0.0, @1.0];
            gradientLayer.startPoint = CGPointMake(0.5, 0.0);
            gradientLayer.endPoint = CGPointMake(0.5, 1);
            
            gradientLayer.frame = CGRectMake(offSetY + ChartLeftPadding + xPosition - 0.5 * barData.barWidth, ChartTopPadding + yStartPosition, barData.barWidth, yEndPosition - yStartPosition);
            [self.layer insertSublayer:gradientLayer atIndex:0];
            
        }
        
        
        
        
        
        
        
        
    }
}

- (void)drawBarWithChartData:(NSArray *)datas {
//    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSInteger count = datas.count > self.xAxisTitles.count ? datas.count : self.xAxisTitles.count;
    
    for (int i = 0; i < count; i++) {
        NSArray *barDatas = datas[i];
        //柱状图x轴定位
        CGFloat xPosition = chartWidth * (i+1)/(count + 1);
        
        //柱状图y轴定位
        CGFloat currentValue = 0.f;
        for (int j = 0; j < barDatas.count; j++) {
            QYBarChartData *barData = barDatas[j];
            
            CGFloat yValue = currentValue + barData.value;
            CGFloat yStartPosition = chartHeight * (1.f -(currentValue - self.yAxisRange.location) / self.yAxisRange.length);
            CGFloat yEndPosition = chartHeight * (1.f -(yValue - self.yAxisRange.location) / self.yAxisRange.length);
            currentValue += barData.value;
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(offSetY + ChartLeftPadding + xPosition, ChartTopPadding + yStartPosition)];
            [path addLineToPoint:CGPointMake(offSetY + ChartLeftPadding + xPosition, ChartTopPadding + yEndPosition)];
            path.lineWidth = barData.barWidth;
            [barData.colors[0] setStroke];
            [path stroke];
            
//            CGContextSetLineWidth(context, barData.barWidth);
//            CGContextSetStrokeColorWithColor(context, barData.colors[1].CGColor);
//            CGContextMoveToPoint(context, offSetY + ChartLeftPadding + xPosition, ChartTopPadding + yStartPosition);
//            CGContextAddLineToPoint(context, offSetY + ChartLeftPadding + xPosition, ChartTopPadding + yEndPosition);
//            CGContextStrokePath(context);
        }
    }
}

@end














