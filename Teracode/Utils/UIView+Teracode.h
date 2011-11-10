//
//  UIView+UIView_Teracode.h
//  Teracode
//
//  Created by Javier Holcman on 11/10/11.
//  Copyright (c) 2011 Teracode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIView_Teracode)

enum {
    TCViewAlignmentTopLeft,
    TCViewAlignmentTopCenter,
    TCViewAlignmentTopRight,
    TCViewAlignmentCenterLeft,
    TCViewAlignmentCenter,
    TCViewAlignmentCenterRight,
    TCViewAlignmentBottomLeft,
    TCViewAlignmentBottomCenter,
    TCViewAlignmentBottomRight
} typedef TCViewAlignment;

@property (nonatomic, assign) float_t x;
@property (nonatomic, assign) float_t y;
@property (nonatomic, assign) float_t width;
@property (nonatomic, assign) float_t height;
@property (nonatomic, assign, readonly) float_t contentHeight;
@property (nonatomic, assign, readonly) float_t contentWidth;

- (void)setX:(float_t)x y:(float_t)y;
- (void)setWidth:(float_t)width height:(float_t)height;
- (void)setX:(float_t)pX y:(float_t)pY width:(float_t)sWidth height:(float_t)sHeight;

- (void)refreshWithFade;

- (void)align:(TCViewAlignment)alignment;
- (void)align:(TCViewAlignment)alignment padding:(float)padding;
- (void)align:(TCViewAlignment)alignment verticalPadding:(float)verticalPadding horizontalPadding:(float)horizontalPadding;

+ (bool)isAlignedAtTop:(TCViewAlignment)alignment;
+ (bool)isAlignedAtVerticalCenter:(TCViewAlignment)alignment;
+ (bool)isAlignedAtBottom:(TCViewAlignment)alignment;
+ (bool)isAlignedAtLeft:(TCViewAlignment)alignment;
+ (bool)isAlignedAtHorizontalCenter:(TCViewAlignment)alignment;
+ (bool)isAlignedAtRight:(TCViewAlignment)alignment;

+ (UIView *)loadFromNib:(NSString *)nibName withOwner:(NSObject *)owner;


@end
