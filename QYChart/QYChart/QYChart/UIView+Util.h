//
//  UIView+Util.h
//  SleepPillow
//
//  Created by 张庆玉 on 25/05/2017.
//  Copyright © 2017 MWellness. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Util)

+ (instancetype)getXIBView;

/** 可视化设置边框宽度 */
@property (nonatomic, assign)IBInspectable CGFloat borderWidth;
/** 可视化设置边框颜色 */
@property (nonatomic, strong)IBInspectable UIColor *borderColor;
/** 可视化设置圆角 */
@property (nonatomic, assign)IBInspectable CGFloat cornerRadius;

@property (assign, nonatomic) CGFloat x_qy;
@property (assign, nonatomic) CGFloat y_qy;
@property (assign, nonatomic) CGFloat w_qy;
@property (assign, nonatomic) CGFloat h_qy;
@property (assign, nonatomic) CGSize size_qy;
@property (assign, nonatomic) CGPoint origin_qy;

// 设置边框线
- (void)setBorderCornerWithBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius;

// 圆形
- (void)setCircleCorner;

/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;

/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect;


- (void)setHorizontalGradientBackColorWithStartColor:(UIColor *)startColor EndColor:(UIColor *)endColor frame:(CGRect)frame;

- (UIImage *)getHorizontalGradientBackImageWithStartColor:(UIColor *)startColor EndColor:(UIColor *)endColor;
@end
