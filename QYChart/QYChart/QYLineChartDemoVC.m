//
//  QYLineChartDemoVC.m
//  QYChart
//
//  Created by 张庆玉 on 16/05/2017.
//  Copyright © 2017 张庆玉. All rights reserved.
//

#import "QYLineChartDemoVC.h"
#import "QYChart.h"

@interface QYLineChartDemoVC ()
@property (weak, nonatomic) IBOutlet QYLineChart *lineChart;

@property (nonatomic, strong) NSMutableArray *lineData;
@property (nonatomic, strong) NSMutableArray *xtitles;

@end

@implementation QYLineChartDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self bornData];
    
    [self setupLineChart];
}

- (void)bornData {
    self.lineData = [NSMutableArray new];
    
    for (NSInteger i = 0; i < 2; i ++ ) {
        NSMutableArray *values = [NSMutableArray new];
        for (int i = 0; i<10; i++) {
            NSInteger rand = random()%10+5;
            CGFloat value = (rand+1) * 5;
            [values addObject:@(value)];
        }
        QYLineChartData * data = [[QYLineChartData alloc] initWithValues:values Color:[UIColor colorWithRed:i*0.5 green:0.3 blue:0.6 alpha:1.f] LineWidth:1.f];
        [self.lineData addObject:data];
    }
    
    self.xtitles = [NSMutableArray new];
    QYLineChartData * data = [self.lineData firstObject];
    for (int i = 0; i<data.values.count; i++) {
        
        NSString *xtitle = [NSString stringWithFormat:@"X%d",i];
        [self.xtitles addObject:xtitle];
        
    }
}

- (void)setupLineChart {
    self.lineChart.yAxisRange = NSMakeRange(0, 100);
    self.lineChart.coordinateColor = [UIColor colorWithRed:0.722 green:0.200 blue:0.631 alpha:1.00];
    self.lineChart.xAxisTitles = self.xtitles;
    
    self.lineChart.chartData = self.lineData;
    
    [self.lineChart drawChart];
}

- (IBAction)changeLineStyle:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:{
            self.lineChart.isCurveLine = NO;
        }
            break;
        case 1:{
            self.lineChart.isCurveLine = YES;
        }
            break;
        default:
            break;
    }
    [self.lineChart drawChart];
}

- (IBAction)changeBackStyle:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:{
            self.lineChart.isGradientRamp = NO;
        }
            break;
        case 1:{
            self.lineChart.isGradientRamp = YES;
        }
            break;
        default:
            break;
    }
    [self.lineChart drawChart];
}

- (IBAction)changeBaseLineStyle:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:{
            self.lineChart.baseLineType = QYNoBaseLine;
        }
            break;
        case 1:{
            self.lineChart.baseLineType = QYDashDotBaseLine;
        }
            break;
        case 2:{
            self.lineChart.baseLineType = QYSolidBaseLine;
        }
            break;
        default:
            break;
    }
    [self.lineChart drawChart];
}

- (IBAction)changeData:(UIStepper *)sender {
    
}

@end











