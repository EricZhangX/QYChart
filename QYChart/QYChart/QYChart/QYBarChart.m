//
//  QYBarChart.m
//  QYChart
//
//  Created by 张庆玉 on 2017/4/19.
//  Copyright © 2017年 张庆玉. All rights reserved.
//

#import "QYBarChart.h"



@interface QYBarChart ()

@property (nonatomic, strong) NSMutableArray *tempSubViews;
@property (nonatomic, strong) NSMutableArray *tempSubLayers;

@end

@implementation QYBarChart

- (NSMutableArray *)tempSubViews {
    if (!_tempSubViews) {
        _tempSubViews = [NSMutableArray new];
    }
    return _tempSubViews;
}

- (NSMutableArray *)tempSubLayers {
    if (!_tempSubLayers) {
        _tempSubLayers = [NSMutableArray new];
    }
    return _tempSubLayers;
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    for (UIView *subView in self.tempSubViews) {
        [subView removeFromSuperview];
    }
    for (CAGradientLayer *layer in self.tempSubLayers) {
        [layer removeFromSuperlayer];
    }
    
    if (self.chartData && self.chartData.count) {
        //[self drawBarWithChartData:self.chartData];
        [self drawChartWithData:self.chartData];
    }
    
    [self drawBaseLine];
}

- (void)drawChartWithData:(NSArray *)datas {
    
    [self.tempSubViews removeAllObjects];
    
    NSInteger count = datas.count > self.xAxisTitles.count ? datas.count : self.xAxisTitles.count;

    for (int i = 0; i < count; i++) {
        NSArray *barDatas = datas[i];
        //柱状图x轴定位
        CGFloat xWidth = (float)chartWidth / count / 2;
        CGFloat xPosition = xWidth * (2 * i + 1);
        //柱状图y轴定位
        CGFloat currentValue = 0.f;
        CGFloat labelWidth = 10;
        
        for (int j = 0; j < barDatas.count; j++) {
            QYBarChartData *barData = barDatas[j];
            labelWidth = barData.barWidth;
            CGFloat yValue = currentValue + barData.value;
            CGFloat yStartPosition = chartHeight * (1.f -(currentValue - self.yAxisRange.location) / self.yAxisRange.length);
            CGFloat yEndPosition = chartHeight * (1.f -(yValue - self.yAxisRange.location) / self.yAxisRange.length);
            currentValue += barData.value;
            
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.colors = @[(__bridge id)[barData.colors firstObject].CGColor, (__bridge id)[barData.colors lastObject].CGColor];
            
            gradientLayer.locations = @[@0.0, @1.0];
            gradientLayer.startPoint = CGPointMake(0.5, 0.0);
            gradientLayer.endPoint = CGPointMake(0.5, 1);
            
            gradientLayer.frame = CGRectMake(offSetY + self.chartLeftPadding + xPosition - 0.5 * barData.barWidth, self.chartTopPadding + yStartPosition, barData.barWidth, yEndPosition - yStartPosition);
            [self.tempSubLayers addObject:gradientLayer];
            [self.layer insertSublayer:gradientLayer atIndex:0];
            
            
        }
        if (self.isShowTopLabel) {
            if ([@(currentValue) integerValue] != 0) {
                CGFloat yTopPosition = chartHeight * (1.f -(currentValue - self.yAxisRange.location) / self.yAxisRange.length);
                
                UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, 16)];
                countLabel.center = CGPointMake(offSetY + self.chartLeftPadding + xPosition, self.chartTopPadding + yTopPosition - 8);
                countLabel.font = [UIFont systemFontOfSize:9];
                countLabel.adjustsFontSizeToFitWidth = YES;
                countLabel.textColor = [UIColor grayColor];
                countLabel.text = [NSString stringWithFormat:@"%.0f",currentValue];
                countLabel.textAlignment = NSTextAlignmentCenter;
                [self addSubview:countLabel];
                [self.tempSubViews addObject:countLabel];
            }
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
            [path moveToPoint:CGPointMake(offSetY + self.chartLeftPadding + xPosition, self.chartTopPadding + yStartPosition)];
            [path addLineToPoint:CGPointMake(offSetY + self.chartLeftPadding + xPosition, self.chartTopPadding + yEndPosition)];
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














