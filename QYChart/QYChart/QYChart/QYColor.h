//
//  QYColor.h
//  QYChart
//
//  Created by 张庆玉 on 2017/4/20.
//  Copyright © 2017年 张庆玉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QYColor : NSObject

@property (nonatomic, assign) int r;
@property (nonatomic, assign) int g;
@property (nonatomic, assign) int b;
@property (nonatomic, assign) float alpha;
@property (nonatomic, assign) float value;

@property (nonatomic, strong) UIColor *color;

- (instancetype)initWithR:(int)r G:(int)g B:(int)b Alpha:(float)alpha Value:(float)value;

@end
