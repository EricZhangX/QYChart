//
//  QYBarChart.h
//  QYChart
//
//  Created by 张庆玉 on 2017/4/19.
//  Copyright © 2017年 张庆玉. All rights reserved.
//

#import "QYCoordinateChart.h"
#import "QYBarChartData.h"

@interface QYBarChart : QYCoordinateChart

//数据源
@property (nonatomic, strong) NSMutableArray<NSArray<QYBarChartData *> *> *chartData;

@end
