//
//  UIView+UIView_Teracode.m
//  Teracode
//
//  Created by Javier Holcman on 11/10/11.
//  Copyright (c) 2011 Teracode. All rights reserved.
//

#import "UIView+Teracode.h"

@implementation UIView (UIView_Teracode)

- (float_t)x {
	return self.frame.origin.x;
}

- (void)setX:(float_t)value {
	self.frame = CGRectMake(value,
							self.frame.origin.y, 
							self.frame.size.width,
							self.frame.size.height);
}

- (float_t)y {
	return self.frame.origin.y;
}

- (void)setY:(float_t)value {
	self.frame = CGRectMake(self.frame.origin.x,
							value, 
							self.frame.size.width,
							self.frame.size.height);
}

- (float_t)width {
	return self.frame.size.width;
}

- (void)setWidth:(float_t)value {
	self.frame = CGRectMake(self.frame.origin.x,
							self.frame.origin.y, 
							value,
							self.frame.size.height);
}

- (float_t)height {
	return self.frame.size.height;
}

- (void)setHeight:(float_t)value {
	self.frame = CGRectMake(self.frame.origin.x,
							self.frame.origin.y, 
							self.frame.size.width,
							value);
}

- (float_t)contentHeight {
	float_t maxHeight = 0.0;
	for (UIView *subView in self.subviews) {
		if (!subView.hidden && subView.alpha > 0) {
			float currentHeight = subView.frame.origin.y + subView.height;
			if (maxHeight < currentHeight) {
				maxHeight = currentHeight;
			}
		}
	}
	return maxHeight;
}

- (float_t)contentWidth {
	float_t maxWidth = 0.0;
	for (UIView *subView in self.subviews) {
		if (!subView.hidden && subView.alpha > 0) {
			float currentWidth = subView.x + subView.width;
			if (maxWidth < currentWidth) {
				maxWidth = currentWidth;
			}
		}
	}
	return maxWidth;
}

- (void)setX:(float_t)x y:(float_t)y {
	self.frame = CGRectMake(x,
							y, 
							self.frame.size.width,
							self.frame.size.height);	
}

- (void)setWidth:(float_t)sWidth height:(float_t)sHeight {
	self.frame = CGRectMake(self.frame.origin.x,
							self.frame.origin.y, 
							sWidth,
							sHeight);	
}

- (void)setX:(float_t)pX y:(float_t)pY width:(float_t)sWidth height:(float_t)sHeight {
	self.frame = CGRectMake(pX,
							pY, 
							sWidth,
							sHeight);	
}

- (void)finishWithFadeIn:(NSString *)animationId finished:(BOOL)finished target:(UIView *)target {
    [UIView beginAnimations:animationId context:target];
    [UIView setAnimationDuration:0.4f];
    [self setAlpha:1.0f];
    [UIView commitAnimations];
}

- (void)refreshWithFade {
    [UIView beginAnimations:@"first" context:self];
    [UIView setAnimationDuration:0.4f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishWithFadeIn:finished:target:)];
    [self setAlpha:0.0f];
    [UIView commitAnimations];
}

- (void)align:(TCViewAlignment)alignment 
{
    [self align:alignment padding:0];
}

- (void)align:(TCViewAlignment)alignment padding:(float)padding
{
    [self align:alignment verticalPadding:padding horizontalPadding:padding];
}

- (void)align:(TCViewAlignment)alignment verticalPadding:(float)verticalPadding horizontalPadding:(float)horizontalPadding
{
    switch (alignment) {
        case TCViewAlignmentTopLeft:
            [self setX: horizontalPadding y: verticalPadding];
            self.autoresizingMask = self.autoresizingMask | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
            break;
            
        case TCViewAlignmentTopCenter:
            [self setX: (self.superview.width / 2) - (self.width / 2) y:verticalPadding];
            self.autoresizingMask = self.autoresizingMask | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
            break;
            
        case TCViewAlignmentTopRight:
            [self setX: self.superview.width - self.width - horizontalPadding y:verticalPadding];
            self.autoresizingMask = self.autoresizingMask | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
            break;
            
        case TCViewAlignmentCenterLeft:
            [self setX:horizontalPadding y:(self.superview.height / 2) - (self.height / 2)];
            self.autoresizingMask = self.autoresizingMask | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
            break;
            
        case TCViewAlignmentCenter:
            [self setX:(self.superview.width / 2) - (self.width / 2) y:(self.superview.height / 2) - (self.height / 2)];
            self.autoresizingMask = self.autoresizingMask | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            break;
            
        case TCViewAlignmentCenterRight:
            [self setX: self.superview.width - self.width - horizontalPadding y:(self.superview.height / 2) - (self.height / 2)];
            self.autoresizingMask = self.autoresizingMask | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
            break;
            
        case TCViewAlignmentBottomLeft:
            [self setX: horizontalPadding y: self.superview.height - self.height - verticalPadding];
            self.autoresizingMask = self.autoresizingMask | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
            break;
            
        case TCViewAlignmentBottomCenter:
            [self setX: (self.superview.width / 2) - (self.width / 2) y: self.superview.height - self.height - verticalPadding];
            self.autoresizingMask = self.autoresizingMask | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            break;
            
        case TCViewAlignmentBottomRight:
            [self setX: self.superview.width - self.width - horizontalPadding y: self.superview.height - self.height - verticalPadding];
            self.autoresizingMask = self.autoresizingMask | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            break;
            
            
        default:
            break;
    }
}

+ (bool)isAlignedAtTop:(TCViewAlignment)alignment {
    return alignment == TCViewAlignmentTopCenter || alignment == TCViewAlignmentTopLeft || alignment == TCViewAlignmentTopRight;
}

+ (bool)isAlignedAtHorizontalCenter:(TCViewAlignment)alignment {
    return alignment == TCViewAlignmentCenter || alignment == TCViewAlignmentCenterLeft || alignment == TCViewAlignmentCenterRight;
}

+ (bool)isAlignedAtBottom:(TCViewAlignment)alignment {
    return alignment == TCViewAlignmentBottomCenter || alignment == TCViewAlignmentBottomLeft || alignment == TCViewAlignmentBottomRight;
}

+ (bool)isAlignedAtLeft:(TCViewAlignment)alignment {
    return alignment == TCViewAlignmentTopLeft || alignment == TCViewAlignmentCenterLeft || alignment == TCViewAlignmentBottomLeft;
}

+ (bool)isAlignedAtVerticalCenter:(TCViewAlignment)alignment {
    return alignment == TCViewAlignmentTopCenter || alignment == TCViewAlignmentCenter || alignment == TCViewAlignmentBottomCenter;
}

+ (bool)isAlignedAtRight:(TCViewAlignment)alignment {
    return alignment == TCViewAlignmentTopRight || alignment == TCViewAlignmentCenterRight || alignment == TCViewAlignmentBottomRight;
}

+ (UIView *)loadFromNib:(NSString *)nibName withOwner:(NSObject *)owner
{
	NSArray *objects = [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil];
	UIView *view = [objects objectAtIndex: 0];
    return view;
}

@end
