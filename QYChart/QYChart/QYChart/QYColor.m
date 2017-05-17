//
//  QYColor.m
//  QYChart
//
//  Created by 张庆玉 on 2017/4/20.
//  Copyright © 2017年 张庆玉. All rights reserved.
//

#import "QYColor.h"

@implementation QYColor

- (instancetype)initWithR:(int)r G:(int)g B:(int)b Alpha:(float)alpha Value:(float)value {
    self = [super init];
    if (self) {
        self.r = r;
        self.g = g;
        self.b = b;
        self.alpha = alpha;
        self.value = value;
        self.color = [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:alpha];
    }
    return self;
}
@end
