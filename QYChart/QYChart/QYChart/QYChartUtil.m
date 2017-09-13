//
//  QYChartUtil.m
//  MWell_Health_PlatForm_IOS
//
//  Created by 张庆玉 on 2017/8/30.
//  Copyright © 2017年 midea. All rights reserved.
//

#import "QYChartUtil.h"

@implementation QYChartUtil

+ (NSString *)checkIsIntergerValueBy:(float)floatValue {
    NSString *numStr = [NSString stringWithFormat:@"%.1f",floatValue];
    if ([numStr floatValue] - [numStr integerValue] == 0) {
        numStr = [NSString stringWithFormat:@"%.0f",floatValue];
    }
    return numStr;
}

@end
