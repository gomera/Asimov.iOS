//
//  TCPopUpViewController.h
//  IRestaurant
//
//  Created by Javier Holcman on 6/1/11.
//  Copyright 2011 Teracode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+Teracode.h"

enum {
    TCPopUpAnimationNone,
    TCPopUpAnimationResized,
    TCPopUpAnimationBounce,
    TCPopUpAnimationTranslation,
    TCPopUpAnimationFromLeft,
    TCPopUpAnimationFromRight,
    TCPopUpAnimationFromTop,
    TCPopUpAnimationFromBottom
} typedef TCPopUpAnimations;

@class TCPopUpView;

@protocol TCPopUpDelegate <NSObject>

@optional

- (void)popUpViewDismissed:(TCPopUpView *)popUp;
- (void)popUpViewPresented:(TCPopUpView *)popUp;

@end

@interface TCPopUpView : UIView {
    UIView *_superView;
    UIView *_contentView;
    
    id<TCPopUpDelegate> _delegate;
    UIView *_backgroundView;
    CGSize _previousSize;
    
    //Animation attributes
    TCPopUpAnimations _animation;
    UIView *_animationTranslationView;
    float _animationDuration;
    BOOL _animationFadeOnMove;
    
    //Visual atributes
    TCViewAlignment _alignment;
    float _backgroundAlpha;
}

- (void)presentInView:(UIView *)superView withContent:(UIView *)contentView size:(CGSize)size animation:(TCPopUpAnimations)animation;
- (void)dismiss;

@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, assign) id<TCPopUpDelegate> delegate;

// Animation properties
@property (nonatomic, assign) TCPopUpAnimations animation;
@property (nonatomic, retain) UIView *animationTranslationView;
@property (nonatomic, assign) float animationDuration;
@property (nonatomic, assign) BOOL animationFadeOnMove;

// Visual prpoerties
@property (nonatomic, assign) float backgroundAlpha;
@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, assign) TCViewAlignment alignment;

@end