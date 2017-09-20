//
//  QYCoordinateChart.h
//  QYChart
//
//  Created by 张庆玉 on 2017/4/19.
//  Copyright © 2017年 张庆玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYChartUtil.h"
#import "UIView+Util.h"


#define NodataMsg @"无测量数据!"

typedef NS_ENUM(NSInteger,QYBaseLineType) {
    QYNoBaseLine        = 0,
    QYDashDotBaseLine,
    QYSolidBaseLine,
};

typedef NS_ENUM(NSInteger,QYCoordinateLineType) {
    QYNoCoordinateLine        = 0,
    QYBottomeCoordinateLine,
    QYLeftCoordinateLine,
    QYLBCoordinateLine,
    QYRightCoordinateLine,
    QYRBCoordinateLine,
    QYFullCoordinateLine
};

typedef NS_ENUM(NSInteger,QYYAxisType) {
    QYNoYAxis        = 0,
    QYLeftYAxis,
    QYRightYAxis,
};


@class QYCoordinateChart;
@protocol QYChartDelegate <NSObject>

- (void)complatedReload:(QYCoordinateChart *)chartView YLabelDetails:(NSArray *)yLabels;

@end


@interface QYCoordinateChart : UIView {
    CGFloat offSetY;
    CGFloat offSetX;
    CGFloat chartWidth;
    CGFloat chartHeight;
}

@property (nonatomic, strong) UILabel *noDataLabel;
@property (nonatomic, weak) id<QYChartDelegate> delegate;

//数据
//X轴数组
@property (nonatomic, strong) NSMutableArray *xAxisTitles;
//y轴数组
@property (nonatomic, strong) NSMutableArray *yAxisTitles;
//y轴数组2
@property (nonatomic, strong) NSMutableArray<NSNumber *> *yAxisValues;
//Y轴取值范围
@property (nonatomic, assign) NSRange yAxisRange;
//底图颜色数组
@property (nonatomic, strong) NSMutableArray<UIColor *> *baseLineColors;

//控制
/**
 底图标线的类型
 */
@property (nonatomic, assign) QYBaseLineType baseLineType;
//坐标轴显示类型
@property (nonatomic, assign) QYCoordinateLineType coordinateLineType;
//y轴显示类型
@property (nonatomic, assign) QYYAxisType yAxisType;
//是否显示x轴title default = YES
@property (nonatomic, assign) BOOL isShowXaxixTitle;
//y轴title 是否与标尺对齐 default = YES
@property (nonatomic, assign) BOOL isYaxixTitleSameLevelWithBaseline;


//颜色
//Y轴字体颜色 default = black
@property (nonatomic, strong) NSArray *yAxisTitleColors;
//X轴字体颜色 default = black
@property (nonatomic, strong) UIColor *xAxisTitleColor;
//坐标轴颜色 default = black
@property (nonatomic, strong) UIColor *coordinateColor;
//底图颜色 default = gray
@property (nonatomic, strong) UIColor *baseLineColor;
//无数据字体颜色
@property (nonatomic, strong) UIColor *noDataLabelColor;


//尺寸
//Y轴Title的宽度 default = 40
@property (nonatomic, assign) CGFloat yAxisTitleWidth;
//y轴Title的偏移量 default = 0
@property (nonatomic, assign) CGFloat yAxisTitleOffset;
//X轴Title的高度 default = 20
@property (nonatomic, assign) CGFloat xAxisTitleHeight;
//x轴Title的偏移量 default = 1
@property (nonatomic, assign) CGFloat xAxisTitleOffset;
//ChartTopPadding default = 8
@property (nonatomic, assign) CGFloat chartTopPadding;
//ChartLeftPadding default = 8
@property (nonatomic, assign) CGFloat chartLeftPadding;
//ChartRightPadding default = 0
@property (nonatomic, assign) CGFloat chartRightPadding;
//ChartDefaultYCount default = 4
@property (nonatomic, assign) NSInteger chartDefaultYCount;

@property (nonatomic, assign) BOOL isXtitleOffset;

//坐标轴宽度 default = 1
@property (nonatomic, assign) CGFloat coordinateLineWidth;

@property (nonatomic, strong) NSMutableArray *markLabelYPositions;

- (void)drawChart;

- (void)drawBaseLine;

@end
