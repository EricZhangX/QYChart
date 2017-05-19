//
//  QYBarChartDemoVC.m
//  QYChart
//
//  Created by 张庆玉 on 19/05/2017.
//  Copyright © 2017 张庆玉. All rights reserved.
//

#import "QYBarChartDemoVC.h"
#import "QYBarChart.h"

@interface QYBarChartDemoVC ()

@property (weak, nonatomic) IBOutlet UIView *chartBaseView;

@property (nonatomic, strong) QYBarChart *barChart;

@end

@implementation QYBarChartDemoVC

- (QYBarChart *)barChart {
    if (!_barChart) {
        _barChart = [[QYBarChart alloc] initWithFrame:CGRectMake(0, 0, self.chartBaseView.bounds.size.width, self.chartBaseView.bounds.size.height)];
        _barChart.yAxisRange = NSMakeRange(0, 20);
        _barChart.coordinateColor = [UIColor colorWithRed:0.722 green:0.200 blue:0.631 alpha:1.00];
        _barChart.isShowYaxixTitle = YES;
        
    }
    return _barChart;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.chartBaseView addSubview:self.barChart];
    [self drawBarChart];
}

- (IBAction)changeBaseLine:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:{
            self.barChart.baseLineType = QYNoBaseLine;
        }
            break;
        case 1:{
            self.barChart.baseLineType = QYDashDotBaseLine;
        }
            break;
        case 2:{
            self.barChart.baseLineType = QYSolidBaseLine;
        }
            break;
        default:
            break;
    }
    [self.barChart drawChart];
}

- (void)drawBarChart {
    NSMutableArray *dataArr = [NSMutableArray new];
    NSMutableArray *titles = [NSMutableArray new];
    
    for (int i = 0; i<10; i++) {
        NSInteger rand = random()%3+1;
        NSMutableArray *barDatas = [NSMutableArray new];
        for (int j = 0;  j< rand; j++) {
            NSInteger k = random()%2 + 1;
            UIColor *color = [UIColor colorWithRed:0.99f/k green:0.44f/k blue:0.77/k alpha:1.00];
            CGFloat value = k * 4;
            
            QYBarChartData *data = [[QYBarChartData alloc] initWithValue:value Width:10.f Color:color];
            [barDatas addObject:data];
        }
        [dataArr addObject:barDatas];
        
        NSString *title = [NSString stringWithFormat:@"X-%d",i];
        [titles addObject:title];
    }
    self.barChart.backgroundColor = [UIColor whiteColor];
    self.barChart.chartData = dataArr;
    self.barChart.yAxisRange = NSMakeRange(0, 50);
    self.barChart.coordinateColor = [UIColor colorWithRed:0.722 green:0.200 blue:0.631 alpha:1.00];
    self.barChart.xAxisTitles = titles;
    [self.barChart drawChart];
}


@end





















