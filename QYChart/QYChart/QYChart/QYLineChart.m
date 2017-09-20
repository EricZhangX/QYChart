//
//  QYLineChart.m
//  QYChart
//
//  Created by 张庆玉 on 2017/4/19.
//  Copyright © 2017年 张庆玉. All rights reserved.
//

#import "QYLineChart.h"

#define StartPointKey   @"StartPointKey"
#define EndPointKey     @"EndPointKey"

@interface QYLineChart ()
/** 渐变背景视图 */
@property (nonatomic, strong) UIView *gradientBackgroundView;
/** 渐变图层 */
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
/** 颜色数组 */
@property (nonatomic, strong) NSMutableArray *gradientLayerColors;
/** 折线/曲线图层 */
@property (nonatomic, strong) CAShapeLayer *lineChartLayer;

@property (nonatomic, strong) NSMutableArray *tempViews;

@end

@implementation QYLineChart

- (NSMutableArray *)tempViews {
    if (!_tempViews) {
        _tempViews = [NSMutableArray new];
    }
    return _tempViews;
}

- (void)setChartData:(NSMutableArray<QYLineChartData *> *)chartData {
    _chartData = [chartData mutableCopy];
    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    for (UIView *view in self.tempViews) {
        [view removeFromSuperview];
    }
    
    if (self.chartData.count) {
        if (self.isGradientRamp) {
            [self drawGradientBackgroundView];
        } else {
            if (self.gradientBackgroundView) {
                [self.gradientBackgroundView removeFromSuperview];
            }
        }
        [self drawLineChart];
    } else {
        self.noDataLabel.text = NodataMsg;
    }
    
    [self drawBaseLine];
}

// 绘制正常曲线
- (void)drawLineChart {
    BOOL haveData = NO;
    CGFloat cicleRadius = 6;
    UIColor *cicleBackColor = [UIColor whiteColor];

    for (NSInteger i = 0; i < self.chartData.count; i++) {
        QYLineChartData *lineData = self.chartData[i];
        NSInteger totalCount = lineData.values.count;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = lineData.color;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [self.tempViews addObject:label];
        
        for (NSInteger j = 0; j < totalCount; j++) {
            if (j > 0) {
                
                NSNumber *num = lineData.values[j];
                NSNumber *lastNum = lineData.values[j-1];
                
                CGPoint startPoint = [self caculateNormalPointWithXindex:j-1 Yvalue:lastNum TotalCount:totalCount];
                CGPoint endPoint = [self caculateNormalPointWithXindex:j Yvalue:num TotalCount:totalCount];
                
                if ([lastNum floatValue] > 0) {
                    haveData = YES;
                    [path moveToPoint:startPoint];
                    [path addLineToPoint:startPoint];
                    
                    if (self.isHideCicle) {
                        cicleRadius = lineData.lineWidth;
                        cicleBackColor = lineData.color;
                    }
                    
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cicleRadius, cicleRadius)];
                    view.backgroundColor = cicleBackColor;
                    [view setBorderCornerWithBorderWidth:lineData.lineWidth borderColor:lineData.color cornerRadius:view.frame.size.width * 0.5];
                    view.center = startPoint;
                    [self addSubview:view];
                    [self.tempViews addObject:view];
                    
                    
                    if (!self.isHideLastTitle) {
                        label.center = CGPointMake(startPoint.x, startPoint.y - 14);
                        NSString *lastNumStr = [QYChartUtil checkIsIntergerValueBy:[lastNum floatValue]];
                        label.text = [NSString stringWithFormat:@"%@%@",lastNumStr,lineData.unit];
                    }
                    
                }
                if ([num floatValue] > 0) {
                    if (self.isCurveLine) {//曲线
                        if ([lastNum floatValue] <= 0) {
                            NSInteger k = j-2;
                            CGPoint kStartPoint = CGPointZero;
                            while (k >= 0) {
                                NSNumber *kNum = lineData.values[k];
                                if ([kNum floatValue] > 0) {
                                    kStartPoint = [self caculateNormalPointWithXindex:k Yvalue:kNum TotalCount:totalCount];
                                    break;
                                }
                                k --;
                            }
                            if (kStartPoint.y > 0) {
                                CGPoint midPoint = [self midPointBetweenPoint1:kStartPoint andPoint2:endPoint];
                                
                                [path addQuadCurveToPoint:midPoint
                                             controlPoint:[self controlPointBetweenPoint1:midPoint andPoint2:kStartPoint]];
                                [path addQuadCurveToPoint:endPoint
                                             controlPoint:[self controlPointBetweenPoint1:midPoint andPoint2:endPoint]];
                            }
                        } else {
                            CGPoint midPoint = [self midPointBetweenPoint1:startPoint andPoint2:endPoint];
                            
                            [path addQuadCurveToPoint:midPoint
                                         controlPoint:[self controlPointBetweenPoint1:midPoint andPoint2:startPoint]];
                            [path addQuadCurveToPoint:endPoint
                                         controlPoint:[self controlPointBetweenPoint1:midPoint andPoint2:endPoint]];
                        }
                        
                    } else {//折线
                        [path addLineToPoint:endPoint];
                    }
                }
                if ([num floatValue] > 0 && j == totalCount - 1) {
                    haveData = YES;
                    [path moveToPoint:endPoint];
                    [path addLineToPoint:endPoint];
                    
                    if (self.isHideCicle) {
                        cicleRadius = lineData.lineWidth;
                        cicleBackColor = lineData.color;
                    }
                    
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cicleRadius, cicleRadius)];
                    view.backgroundColor = cicleBackColor;
                    [view setBorderCornerWithBorderWidth:lineData.lineWidth borderColor:lineData.color cornerRadius:view.frame.size.width * 0.5];
                    view.center = endPoint;
                    [self addSubview:view];
                    [self.tempViews addObject:view];
                    
                    if (!self.isHideLastTitle) {
                        label.center = CGPointMake(endPoint.x, endPoint.y - 14);
                        NSString *numStr = [QYChartUtil checkIsIntergerValueBy:[num floatValue]];
                        label.text = [NSString stringWithFormat:@"%@%@",numStr,lineData.unit];
                    }
                }
            }
        }
        if (self.isGradientRamp) {
            switch (self.baseLineType) {
                case QYNoBaseLine:
                    break;
                case QYDashDotBaseLine:{
                    if (self.yAxisValues.count) {
                        //绘制网格
                        for (NSInteger i=0; i<self.yAxisValues.count; i++) {
                            NSNumber *value = self.yAxisValues[i];
                            CGFloat num = [value floatValue];
                            CGFloat yPosition = chartHeight * (1.f -(num - self.yAxisRange.location) / self.yAxisRange.length);
                            NSInteger k = 0;
                            while (k < chartWidth) {
                                [path moveToPoint:CGPointMake(k, yPosition)];
                                [path addLineToPoint:CGPointMake(k + 2, yPosition)];
                                k += 4;
                            }
                        }
                    }
                }
                    break;
                case QYSolidBaseLine:{
                    if (self.yAxisValues.count) {
                        //绘制网格
                        for (NSInteger i=0; i<self.yAxisValues.count; i++) {
                            NSNumber *value = self.yAxisValues[i];
                            CGFloat num = [value floatValue];
                            CGFloat yPosition = chartHeight * (1.f -(num - self.yAxisRange.location) / self.yAxisRange.length);
                            
                            [path moveToPoint:CGPointMake(0, yPosition)];
                            [path addLineToPoint:CGPointMake(chartWidth, yPosition)];
                        }
                    }
                }
                    break;
                default:
                    break;
            }
            
            self.lineChartLayer = [CAShapeLayer layer];
            self.lineChartLayer.strokeColor = [UIColor whiteColor].CGColor;
            self.lineChartLayer.fillColor = [[UIColor clearColor] CGColor];
            self.lineChartLayer.lineCap = kCALineCapRound;
            self.lineChartLayer.lineJoin = kCALineJoinRound;
            self.lineChartLayer.path = path.CGPath;
            self.lineChartLayer.lineWidth = 1.f;
            self.gradientBackgroundView.layer.mask = self.lineChartLayer;
        } else {
            path.lineWidth = lineData.lineWidth;
            [lineData.color setStroke];
            [path stroke];
        }
        
        if (haveData) {
            self.noDataLabel.text = @"";
        } else {
            self.noDataLabel.text = NodataMsg;
        }
    }
    
}

// 绘制渐变背景视图（不包含坐标轴）
- (void)drawGradientBackgroundView {
    if (self.gradientBackgroundView) {
        [self.gradientBackgroundView removeFromSuperview];
    }
    self.gradientBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(offSetY + self.chartLeftPadding + .5, self.chartTopPadding, chartWidth-.5, chartHeight-.5)];
    [self addSubview:self.gradientBackgroundView];
    /** 创建并设置渐变背景图层 */
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.gradientBackgroundView.bounds;
    //设置渐变区域的起始和终止位置（范围为0-1），即渐变路径
    self.gradientLayer.startPoint = CGPointMake(0, 1.0);
    self.gradientLayer.endPoint = CGPointMake(0.0, 0.0);
    //设置颜色的渐变过程
    self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor greenColor].CGColor, (__bridge id)[UIColor redColor].CGColor]];
    self.gradientLayer.colors = self.gradientLayerColors;
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.gradientBackgroundView.layer addSublayer:self.gradientLayer];
}

//正常情况下获取定位
- (CGPoint)caculateNormalPointWithXindex:(NSInteger)xindex Yvalue:(NSNumber *)yvalue TotalCount:(NSInteger)totalCount {
    if (self.isGradientRamp) {
        CGFloat num = [yvalue floatValue];
        CGFloat xPosition = (chartWidth * (xindex+1)/(totalCount + 1));
        CGFloat yPosition = chartHeight - (chartHeight * ((num - self.yAxisRange.location) / self.yAxisRange.length));
        return CGPointMake(xPosition, yPosition);
    } else {
        if (self.isFullWidth) {
            CGFloat num = [yvalue floatValue];
            CGFloat xPosition = offSetY + self.chartLeftPadding + (chartWidth * xindex/(totalCount));
            CGFloat yPosition = self.bounds.size.height - offSetX - (chartHeight * ((num - self.yAxisRange.location) / self.yAxisRange.length));
            return CGPointMake(xPosition, yPosition);
        } else {
            CGFloat num = [yvalue floatValue];
            CGFloat xPosition = offSetY + self.chartLeftPadding + (chartWidth * (xindex+1)/(totalCount + 1));
            CGFloat yPosition = self.bounds.size.height - offSetX - (chartHeight * ((num - self.yAxisRange.location) / self.yAxisRange.length));
            return CGPointMake(xPosition, yPosition);
        }
    }
}

- (CGPoint)midPointBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2 {
    return CGPointMake((point1.x + point2.x) / 2, (point1.y + point2.y) / 2);
}

- (CGPoint)controlPointBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2 {
    CGPoint controlPoint = [self midPointBetweenPoint1:point1 andPoint2:point2];
    CGFloat diffY = abs((int) (point2.y - controlPoint.y));
    if (point1.y < point2.y)
        controlPoint.y += diffY;
    else if (point1.y > point2.y)
        controlPoint.y -= diffY;
    return controlPoint;
}

@end












