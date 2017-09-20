//
//  QYCoordinateChart.m
//  QYChart
//
//  Created by 张庆玉 on 2017/4/19.
//  Copyright © 2017年 张庆玉. All rights reserved.
//

#import "QYCoordinateChart.h"

@interface QYCoordinateChart ()

@property (nonatomic, strong) NSMutableArray *xLabels;
@property (nonatomic, strong) NSMutableArray *yLabels;

@end

@implementation QYCoordinateChart

- (UILabel *)noDataLabel {
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(offSetX, self.chartTopPadding, chartWidth, chartHeight)];
        _noDataLabel.backgroundColor = [UIColor clearColor];
        _noDataLabel.textColor = self.noDataLabelColor ? self.noDataLabelColor : [UIColor whiteColor];
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        _noDataLabel.font = [UIFont systemFontOfSize:10];
        [self insertSubview:_noDataLabel atIndex:1000];
    }
    return _noDataLabel;
}

- (NSMutableArray *)markLabelYPositions {
    if (!_markLabelYPositions) {
        _markLabelYPositions = [NSMutableArray new];
    }
    return _markLabelYPositions;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDefaultValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaultValues];
    }
    return self;
}

- (void)setupDefaultValues {
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds   = YES;
    
    //数据
    _xAxisTitles = [NSMutableArray new];
    _yAxisTitles = [NSMutableArray new];
    _yAxisValues = [NSMutableArray new];
    //控制
  
    _baseLineType = QYNoBaseLine;
    _isShowXaxixTitle = YES;
    _isYaxixTitleSameLevelWithBaseline = YES;
    //颜色
    _yAxisTitleColors = @[[UIColor blackColor]];
    _xAxisTitleColor = [UIColor blackColor];
    _coordinateColor = [UIColor blackColor];
    _baseLineColor = [UIColor grayColor];
    //尺寸
    _yAxisTitleWidth = 40;
    _yAxisTitleOffset = 0;
    _xAxisTitleHeight = 20;
    _xAxisTitleOffset = 0;
    _coordinateLineWidth = 1;
    _chartTopPadding = 8.f;
    _chartLeftPadding = 8.f;
    _chartRightPadding = 0.f;
    _chartDefaultYCount = 4;
    
    //--
    _xLabels = [NSMutableArray new];
    _yLabels = [NSMutableArray new];
    
    [self caculateCommonValue];
}

- (void)caculateCommonValue {
    offSetY = 0;
    chartWidth = self.bounds.size.width - self.chartLeftPadding - offSetY - self.chartRightPadding;
    switch (self.yAxisType) {
        case QYNoYAxis: {
        }
            break;
        case QYLeftYAxis: {
            offSetY = self.yAxisTitleWidth - self.yAxisTitleOffset;
        }
            break;
        case QYRightYAxis: {
            chartWidth = self.bounds.size.width - self.chartLeftPadding - offSetY - self.chartRightPadding - self.yAxisTitleWidth;
        }
            break;
        default:
            break;
    }
    offSetX = self.isShowXaxixTitle ? (self.xAxisTitleHeight - self.xAxisTitleOffset) : 0;
    chartHeight = self.bounds.size.height - self.chartTopPadding - offSetX;
}

- (void)drawChart {
    [self caculateCommonValue];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [self drawCoordinateWithContext];
    //[self drawBaseLine];
    
    if (self.isShowXaxixTitle) {
        [self drawXLabels];
    }
    [self drawYLabels];
}

- (void)drawXLabels {
    if (self.xLabels.count) {
        [self.xLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.xLabels removeAllObjects];
    }
    if (self.xAxisTitles.count == 0) {
        return;
    }
    CGFloat xWidth = (float)chartWidth / self.xAxisTitles.count / 2;
    
    for (int i = 0; i < self.xAxisTitles.count; i++) {
        CGFloat xPosition = xWidth * (2 * i + 1);
        CGFloat labelWidth = xWidth * 2;

        UILabel *xlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, labelWidth, self.xAxisTitleHeight)];
        xlabel.font                      = [UIFont systemFontOfSize:9.0f];
        xlabel.backgroundColor           = [UIColor clearColor];
        xlabel.textColor                 = self.xAxisTitleColor;
        xlabel.userInteractionEnabled    = YES;
        xlabel.adjustsFontSizeToFitWidth = YES;
        xlabel.numberOfLines             = 1;
        xlabel.text                      = self.xAxisTitles[i];
        xlabel.adjustsFontSizeToFitWidth = YES;
        if (self.isXtitleOffset) {
            xlabel.textAlignment = NSTextAlignmentLeft;
        } else {
            xlabel.textAlignment = NSTextAlignmentCenter;
        }
        xlabel.center = CGPointMake(offSetY + self.chartLeftPadding + xPosition, self.bounds.size.height - offSetX + self.xAxisTitleHeight * 0.5);
        
        [self.xLabels addObject:xlabel];
        [self addSubview:xlabel];
    }
}

- (void)drawYLabels {
    
    [self.markLabelYPositions removeAllObjects];
    [self.yAxisValues removeAllObjects];
    [self.yAxisTitles removeAllObjects];
    
    if (self.yAxisType == QYNoYAxis) return;
    
    if (self.yLabels.count) {
        [self.yLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.yLabels removeAllObjects];
    }
    
    if (!self.yAxisValues.count) {
        NSInteger length = self.yAxisRange.length / self.chartDefaultYCount;
        for (int i = 0; i < self.chartDefaultYCount; i++) {
            NSInteger num = self.yAxisRange.location + length * i;
            [self.yAxisValues addObject:@(num)];
        }
    }
    
    if (!self.yAxisTitles.count) {
        for (int i = 0; i < self.yAxisValues.count; i++) {
            NSNumber *num = self.yAxisValues[i];
            NSString *ytitle = [NSString stringWithFormat:@"%@",num];
            [self.yAxisTitles addObject:ytitle];
        }
    }
    
    for (int i = 0; i < self.yAxisTitles.count; i++) {
        if (i >= self.yAxisValues.count) {
            break;
        }
        CGFloat yPosition = 0.f;
        
        NSNumber *value = self.yAxisValues[i];
        CGFloat num = [value floatValue];
        if (self.isYaxixTitleSameLevelWithBaseline) {
            yPosition = chartHeight * ((num - self.yAxisRange.location) / self.yAxisRange.length);
        } else {
            NSNumber *lastValue = @(self.yAxisRange.location);
            if (i > 0) {
                lastValue = self.yAxisValues[i-1];
            }
            CGFloat lastNum = [lastValue floatValue];
            CGFloat avgNum = lastNum + (num - lastNum) * 0.5;
            yPosition = chartHeight * ((avgNum - self.yAxisRange.location) / self.yAxisRange.length);
        }
        
        CGFloat labelHeight = 24;//chartHeight/self.xAxisTitles.count;
        
        UILabel *ylabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.yAxisTitleWidth, labelHeight)];
        ylabel.font                      = [UIFont systemFontOfSize:9.0f];
        ylabel.backgroundColor           = [UIColor clearColor];
        UIColor *textColor = [UIColor blackColor];
        if (i < self.yAxisTitleColors.count) {
            textColor = self.yAxisTitleColors[i];
        } else {
            textColor = [self.yAxisTitleColors lastObject];
        }
        ylabel.textColor                 = textColor;
        ylabel.textAlignment             = NSTextAlignmentCenter;
        ylabel.userInteractionEnabled    = YES;
        ylabel.adjustsFontSizeToFitWidth = YES;
        ylabel.numberOfLines             = 0;
        ylabel.text                      = self.yAxisTitles[i];
        if (self.yAxisType == QYLeftYAxis) {
            ylabel.center = CGPointMake(self.yAxisTitleOffset + self.yAxisTitleWidth * 0.5, self.bounds.size.height - yPosition - offSetX);
        } else if (self.yAxisType == QYRightYAxis) {
            ylabel.center = CGPointMake(self.bounds.size.width - self.yAxisTitleOffset - self.yAxisTitleWidth * 0.5, self.bounds.size.height - yPosition - offSetX);
        }
        [self.markLabelYPositions addObject:@[@(self.bounds.size.height - yPosition - offSetX),self.yAxisTitles[i]]];
        
        [self.yLabels addObject:ylabel];
        [self addSubview:ylabel];
        
    }
}

#pragma mark - Draw Coordinate
- (void)drawCoordinateWithContext {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    switch (self.coordinateLineType) {
        case QYNoCoordinateLine:{
        }
            break;
        case QYBottomeCoordinateLine:{
            CGContextSetStrokeColorWithColor(context, self.coordinateColor.CGColor);
            CGContextMoveToPoint(context, offSetY + self.chartLeftPadding, self.chartTopPadding + chartHeight);
            CGContextAddLineToPoint(context, offSetY + self.chartLeftPadding + chartWidth, self.chartTopPadding + chartHeight);
            CGContextStrokePath(context);
        }
            break;
        case QYLeftCoordinateLine:{
            CGContextSetStrokeColorWithColor(context, self.coordinateColor.CGColor);
            CGContextMoveToPoint(context, offSetY + self.chartLeftPadding, self.chartTopPadding);
            CGContextAddLineToPoint(context, offSetY + self.chartLeftPadding, self.chartTopPadding + chartHeight);
            CGContextStrokePath(context);
        }
            break;
        case QYLBCoordinateLine:{
            CGContextSetStrokeColorWithColor(context, self.coordinateColor.CGColor);
            CGContextMoveToPoint(context, offSetY + self.chartLeftPadding, self.chartTopPadding);
            CGContextAddLineToPoint(context, offSetY + self.chartLeftPadding, self.chartTopPadding + chartHeight);
            CGContextStrokePath(context);
            
            CGContextSetStrokeColorWithColor(context, self.coordinateColor.CGColor);
            CGContextMoveToPoint(context, offSetY + self.chartLeftPadding, self.chartTopPadding + chartHeight);
            CGContextAddLineToPoint(context, offSetY + self.chartLeftPadding + chartWidth, self.chartTopPadding + chartHeight);
            CGContextStrokePath(context);
        }
            break;
        case QYRightCoordinateLine:{
            CGContextSetStrokeColorWithColor(context, self.coordinateColor.CGColor);
            CGContextMoveToPoint(context, offSetY + self.chartLeftPadding + chartWidth, self.chartTopPadding);
            CGContextAddLineToPoint(context, offSetY + self.chartLeftPadding + chartWidth, self.chartTopPadding + chartHeight);
            CGContextStrokePath(context);
        }
            break;
        case QYRBCoordinateLine:{
            CGContextSetStrokeColorWithColor(context, self.coordinateColor.CGColor);
            CGContextMoveToPoint(context, offSetY + self.chartLeftPadding + chartWidth, self.chartTopPadding);
            CGContextAddLineToPoint(context, offSetY + self.chartLeftPadding + chartWidth, self.chartTopPadding + chartHeight);
            CGContextStrokePath(context);
            
            CGContextSetStrokeColorWithColor(context, self.coordinateColor.CGColor);
            CGContextMoveToPoint(context, offSetY + self.chartLeftPadding, self.chartTopPadding + chartHeight);
            CGContextAddLineToPoint(context, offSetY + self.chartLeftPadding + chartWidth, self.chartTopPadding + chartHeight);
            CGContextStrokePath(context);
        }
            break;
        case QYFullCoordinateLine:{
            CGContextSetStrokeColorWithColor(context, self.coordinateColor.CGColor);
            CGContextMoveToPoint(context, offSetY + self.chartLeftPadding, self.chartTopPadding);
            CGContextAddLineToPoint(context, offSetY + self.chartLeftPadding, self.chartTopPadding + chartHeight);
            CGContextStrokePath(context);
            
            CGContextSetStrokeColorWithColor(context, self.coordinateColor.CGColor);
            CGContextMoveToPoint(context, offSetY + self.chartLeftPadding, self.chartTopPadding + chartHeight);
            CGContextAddLineToPoint(context, offSetY + self.chartLeftPadding + chartWidth, self.chartTopPadding + chartHeight);
            CGContextStrokePath(context);
            
            CGContextSetStrokeColorWithColor(context, self.coordinateColor.CGColor);
            CGContextMoveToPoint(context, offSetY + self.chartLeftPadding + chartWidth, self.chartTopPadding);
            CGContextAddLineToPoint(context, offSetY + self.chartLeftPadding + chartWidth, self.chartTopPadding + chartHeight);
            CGContextStrokePath(context);
            
            CGContextSetStrokeColorWithColor(context, self.coordinateColor.CGColor);
            CGContextMoveToPoint(context, offSetY + self.chartLeftPadding, self.chartTopPadding);
            CGContextAddLineToPoint(context, offSetY + self.chartLeftPadding + chartWidth, self.chartTopPadding);
            CGContextStrokePath(context);
        }
            break;
        default:
            break;
    }

}

// 绘制网格
- (void)drawBaseLine {
    switch (self.baseLineType) {
        case QYNoBaseLine:
            break;
        case QYDashDotBaseLine:{
            [self drawDashDotLine];
        }
            break;
        case QYSolidBaseLine:{
            [self drawSolidLine];
        }
            break;
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(complatedReload:YLabelDetails:)]) {
        [self.delegate complatedReload:self YLabelDetails:self.markLabelYPositions];
    }
}

- (void)drawDashDotLine {
    
    if (!self.yAxisValues.count) {
        return;
    }
    //绘制虚线网格
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 设置上下文环境 属性
    CGFloat dashLineWidth = 1.f;
    CGContextSetLineWidth(context, dashLineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGFloat alilengths[2] = {1, 2};
    CGContextSetLineDash(context, 0, alilengths, 2);
    // 画横虚线
    for (NSInteger i=0; i<self.yAxisValues.count; i++) {
        NSNumber *value = self.yAxisValues[i];
        CGFloat num = [value floatValue];
        CGFloat yPosition = chartHeight * (1.f -(num - self.yAxisRange.location) / self.yAxisRange.length);
        
        if (self.baseLineColors.count) {
            if (self.baseLineColors.count > i) {
                self.baseLineColor = self.baseLineColors[i];
            } else {
                self.baseLineColor = [self.baseLineColors lastObject];
            }
            CGContextSetStrokeColorWithColor(context, self.baseLineColor.CGColor);
        }
        
        CGPoint startPoint = CGPointMake(offSetY + self.chartLeftPadding, self.chartTopPadding + yPosition);
        CGPoint endPoint = CGPointMake(offSetY + self.chartLeftPadding + chartWidth, self.chartTopPadding + yPosition);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, nil, startPoint.x, startPoint.y );
        CGPathAddLineToPoint(path, nil, endPoint.x, endPoint.y );
        CGContextAddPath(context, path);
        CGContextDrawPath(context, kCGPathEOFillStroke);
        CGPathRelease(path);
    }
    CGFloat alilengths2[2] = {5, 0};
    CGContextSetLineDash(context, 0, alilengths2, 2);
    
}

- (void)drawSolidLine {
    //绘制实线网格
    if (!self.yAxisValues.count) {
        return;
    }
    
    //绘制实线网格
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.baseLineColor.CGColor);
    for (NSInteger i=0; i<self.yAxisValues.count; i++) {
        NSNumber *value = self.yAxisValues[i];
        CGFloat num = [value floatValue];
        CGFloat yPosition = chartHeight * (1.f -(num - self.yAxisRange.location) / self.yAxisRange.length);
        
        if (self.baseLineColors.count) {
            if (self.baseLineColors.count > i) {
                self.baseLineColor = self.baseLineColors[i];
            } else {
                self.baseLineColor = [self.baseLineColors lastObject];
            }
            CGContextSetStrokeColorWithColor(context, self.baseLineColor.CGColor);
        }
        
        CGContextMoveToPoint(context, offSetY + self.chartLeftPadding, self.chartTopPadding + yPosition);
        CGContextAddLineToPoint(context, offSetY + self.chartLeftPadding + chartWidth, self.chartTopPadding + yPosition);
        CGContextStrokePath(context);
    }
}


@end













