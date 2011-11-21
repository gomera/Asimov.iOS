//
//  TCPopUpViewController.m
//  IRestaurant
//
//  Created by Javier Holcman on 6/1/11.
//  Copyright 2011 Teracode. All rights reserved.
//

#import "TCPopUpView.h"
#import "UIView+Teracode.h"

@interface TCPopUpView ()

- (void)initialize;
- (void)createBackgroundView;

- (void)finishResizeOnHeight:(NSString *)animationId finished:(BOOL)finished target:(UIView *)target;
- (void)finishForClose:(NSString *)animationId finished:(BOOL)finished target:(UIView *)target;
- (void)finishResizeOnWidth:(NSString *)animationId finished:(BOOL)finished target:(UIView *)target;
- (void)finishResizeOnOpen:(NSString *)animationId finished:(BOOL)finished target:(UIView *)target;
- (void)finishTranslationOnOpen:(NSString *)animationId finished:(BOOL)finished target:(UIView *)target;
- (void)finishTranslationOnClose:(NSString *)animationId finished:(BOOL)finished target:(UIView *)target;

- (void)presentAnimationFromOrigin:(CGPoint)origin;
- (void)presentAnimationResized;
- (void)presentAnimationNone;
- (void)presentAnimationTranslation;
- (void)presentAnimationFromLeft;
- (void)presentAnimationFromRight;
- (void)presentAnimationFromTop;
- (void)presentAnimationFromBottom;
- (void)dismissAnimationResized;
- (void)dismissAnimationNone;
- (void)dismissAnimationTranslation;
- (void)dismissAnimationFromLeft;
- (void)dismissAnimationFromRight;
- (void)dismissAnimationFromTop;
- (void)dismissAnimationFromBottom;
- (void)dismissAnimationFromOrigin:(CGPoint)origin;
- (void)commonDimiss;

@property (nonatomic, assign) UIView *contentView;
@property (nonatomic, assign) UIView *superView;

@end

@implementation TCPopUpView

@synthesize contentView = _contentView;
@synthesize superView = _superView;
@synthesize backgroundView = _backgroundView;
@synthesize delegate = _delegate;

@synthesize animationTranslationView = _animationTranslationView;
@synthesize animationDuration = _animationDuration;
@synthesize animation = _animation;
@synthesize animationFadeOnMove = _animationFadeOnMove;

@synthesize backgroundAlpha = _backgroundAlpha;
@synthesize backgroundColor = _backgroundColor;
@synthesize alignment = _alignment;

// Constructors and initialization
- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor blackColor];
    self.backgroundAlpha = 0.3f;
    self.animationDuration = 0.3f;
    self.animationFadeOnMove = YES;
    self.alignment = TCViewAlignmentCenter;
}

- (void)createBackgroundView {
    UIView *auxBackgroundView = [[UIView alloc] init];
    self.backgroundView = auxBackgroundView;
    [auxBackgroundView release];
    
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundView.backgroundColor = self.backgroundColor;
    self.backgroundView.frame = CGRectMake(0, 0, self.superView.width, self.superView.height);
    
    if (self.animation == TCPopUpAnimationNone) {
        self.backgroundView.alpha = 1;
        [self.superView addSubview:self.backgroundView];    
    }
    else {
        self.backgroundView.alpha = 0;
        [self.superView addSubview:self.backgroundView];
        
        [UIView beginAnimations:@"1" context:self];
        self.backgroundView.alpha = self.backgroundAlpha;
        [UIView commitAnimations];
    }
}

- (void)presentInView:(UIView *)superView withContent:(UIView *)contentView size:(CGSize)size animation:(TCPopUpAnimations)animation {
    self.animation = animation;
    self.superView = superView;
    self.contentView = contentView;
    
    self.frame = CGRectMake(0, 0, size.width, size.height);
    [self addSubview:self.contentView];
    
    [self createBackgroundView];
    
    switch (animation) {
        case TCPopUpAnimationResized:
            [self presentAnimationResized];
            break;
                        
        case TCPopUpAnimationNone:
            [self presentAnimationNone];
            break;
            
        case TCPopUpAnimationTranslation:
            [self presentAnimationTranslation];
            break;
            
        case TCPopUpAnimationFromLeft:
            [self presentAnimationFromLeft];
            break;
            
        case TCPopUpAnimationFromRight:
            [self presentAnimationFromRight];
            break;
            
        case TCPopUpAnimationFromTop:
            [self presentAnimationFromTop];
            break;
            
        case TCPopUpAnimationFromBottom:
            [self presentAnimationFromBottom];
            break;
            
        default:
            break;
    }
}

- (void)presentAnimationResized {
    _previousSize = self.frame.size;    
    
    // I need to reduce the view up to be a point and align it
    [self setWidth:5 height:5];
    [self.superView addSubview:self];
    
    [self align:self.alignment];
    
    [UIView beginAnimations:@"1" context:self];
    [UIView setAnimationDuration:self.animationDuration];
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDidStopSelector:@selector(finishResizeOnHeight:finished:target:)];
    
    if ([UIView isAlignedAtLeft:self.alignment]) {
        [self setX: self.x 
                      y: self.y 
                  width: _previousSize.width 
                 height: self.height];        
    }
    
    if ([UIView isAlignedAtVerticalCenter:self.alignment]) {
        [self setX: self.x - _previousSize.width / 2
                      y: self.y
                  width: _previousSize.width 
                 height: self.height];    
    }
    
    if ([UIView isAlignedAtRight:self.alignment]) {
        [self setX: self.x - _previousSize.width
                      y: self.y 
                  width: _previousSize.width 
                 height: self.height];     
    }
    
    [UIView commitAnimations];
}

- (void)presentAnimationNone {
    [self.superView addSubview:self];
    [self align:self.alignment];    
    
    if (self.delegate) {
        [self.delegate popUpViewPresented:self];
    }
}

- (void)presentAnimationTranslation {
    _previousSize = self.frame.size;
    
    self.alpha = 0.0f;
    self.backgroundView.alpha = 0.0f;
    
    [self setX:_animationTranslationView.x 
                  y:_animationTranslationView.y 
              width:_animationTranslationView.width 
             height:_animationTranslationView.height];
    
    [self.superView addSubview:self];
    
    [UIView beginAnimations:@"1" context:self];
    [UIView setAnimationDuration:self.animationDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishTranslationOnOpen:finished:target:)];
    
    [self setWidth: _previousSize.width height: _previousSize.height];
    [self align:self.alignment];
    
    self.alpha = 1.0f;
    self.backgroundView.alpha = self.backgroundAlpha;
    
    [UIView commitAnimations];
}

- (void)presentAnimationFromOrigin:(CGPoint)origin {    
    [self.superView addSubview:self];
    [self align:self.alignment];
    
    [self setX: (origin.x != 0 ? origin.x : self.x)
                  y: (origin.y != 0 ? origin.y : self.y)
              width: self.width 
             height: self.height];    
    
    self.alpha = (self.animationFadeOnMove ? 0.0f : 1.0f);
    self.backgroundView.alpha = 0.0f;
    
    [UIView beginAnimations:@"1" context:self];
    [UIView setAnimationDuration:self.animationDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishTranslationOnOpen:finished:target:)];
    
    [self align:self.alignment];
    
    self.alpha = 1.0f;
    self.backgroundView.alpha = self.backgroundAlpha;
    
    [UIView commitAnimations];
}

- (void)presentAnimationFromLeft {
    CGPoint origin = CGPointMake(self.width * (-1), 0);
    [self presentAnimationFromOrigin:origin];
}

- (void)presentAnimationFromRight {
    CGPoint origin = CGPointMake(self.superView.width + self.superView.width, 0);
    [self presentAnimationFromOrigin:origin];
}

- (void)presentAnimationFromTop {
    CGPoint origin = CGPointMake(0, self.height * (-1));
    [self presentAnimationFromOrigin:origin];
}

- (void)presentAnimationFromBottom {
    CGPoint origin = CGPointMake(0, self.height + self.superView.height);
    [self presentAnimationFromOrigin:origin];
}

- (void)finishResizeOnHeight:(NSString *)animationId finished:(BOOL)finished target:(UIView *)target {
    [UIView beginAnimations:animationId context:target];
    [UIView setAnimationDuration:self.animationDuration];
    
    
    if ([UIView isAlignedAtTop:self.alignment]) {
        [self setX: self.x 
                      y: 0 
                  width: _previousSize.width 
                 height: _previousSize.height];        
    }
    
    if ([UIView isAlignedAtHorizontalCenter:self.alignment]) {
        [self setX: self.x 
                      y: self.y - (_previousSize.height / 2) 
                  width: _previousSize.width 
                 height: _previousSize.height];        
    }
    
    if ([UIView isAlignedAtBottom:self.alignment]) {
        [self setX: self.x 
                      y: self.y - _previousSize.height 
                  width: _previousSize.width 
                 height: _previousSize.height];        
    }
    
    [UIView commitAnimations];
}

- (void)finishResizeOnOpen:(NSString *)animationId finished:(BOOL)finished target:(UIView *)target {
    if (self.delegate && [self.delegate respondsToSelector:@selector(popUpViewPresented:)]) {
        [self.delegate popUpViewPresented:self];
    }
}

- (void)finishTranslationOnOpen:(NSString *)animationId finished:(BOOL)finished target:(UIView *)target {
    if (self.delegate && [self.delegate respondsToSelector:@selector(popUpViewPresented:)]) {
        [self.delegate popUpViewPresented:self];
    }    
}

//Dismiss of views
- (void)dismiss {
    switch (self.animation) {
        case TCPopUpAnimationResized:
            [self dismissAnimationResized];
            break;
            
        case TCPopUpAnimationNone:
            [self dismissAnimationNone];
            break;
            
        case TCPopUpAnimationTranslation:
            [self dismissAnimationTranslation];
            break;
            
        case TCPopUpAnimationFromLeft:
            [self dismissAnimationFromLeft];
            break;
            
        case TCPopUpAnimationFromRight:
            [self dismissAnimationFromRight];
            break;
            
        case TCPopUpAnimationFromTop:
            [self dismissAnimationFromTop];
            break;
            
        case TCPopUpAnimationFromBottom:
            [self dismissAnimationFromBottom];
            break;
            
        default:
            break;
    }
}

- (void)dismissAnimationNone {
    [self removeFromSuperview];
    [self.backgroundView removeFromSuperview];    
    if (self.delegate) {
        [self.delegate popUpViewDismissed:self];
    }
}

- (void)dismissAnimationTranslation {
    [UIView beginAnimations:@"1" context:self];
    [UIView setAnimationDuration:self.animationDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishTranslationOnClose:finished:target:)];
    
    [self setX: _animationTranslationView.x
                  y: _animationTranslationView.y
              width: _animationTranslationView.width
             height: _animationTranslationView.height];
    self.alpha = 0.0f;
    self.backgroundView.alpha = 0.0f;
    [UIView commitAnimations];    
}

- (void)dismissAnimationFromLeft {
    CGPoint origin = CGPointMake(self.width * (-1), self.y);
    [self dismissAnimationFromOrigin:origin];
}

- (void)dismissAnimationFromRight {
    CGPoint origin = CGPointMake(self.superView.width + self.width, self.y);
    [self dismissAnimationFromOrigin:origin];
}

- (void)dismissAnimationFromTop {
    CGPoint origin = CGPointMake(self.x, self.height * (-1));
    [self dismissAnimationFromOrigin:origin];
}

- (void)dismissAnimationFromBottom {
    CGPoint origin = CGPointMake(self.x, self.height + self.superView.height);
    [self dismissAnimationFromOrigin:origin];
}

- (void)dismissAnimationResized {
    [UIView beginAnimations:@"2" context:self];
    [UIView setAnimationDuration:self.animationDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishResizeOnWidth:finished:target:)];
    
    if ([UIView isAlignedAtTop:self.alignment]) {
        [self setX:self.x y:0 width:self.width height:5];    
    }
    
    if ([UIView isAlignedAtHorizontalCenter:self.alignment]) {
        [self setX:self.x y:self.y + self.height / 2 width:self.width height:5];    
    }
    
    if ([UIView isAlignedAtBottom:self.alignment]) {
        [self setX:self.x y:self.superview.height - 5 width:self.width height:5];    
    }
    
    
    self.backgroundView.alpha = 0.0f;
    [UIView commitAnimations];
}

- (void)dismissAnimationFromOrigin:(CGPoint)origin {
    [UIView beginAnimations:@"2" context:self];
    [UIView setAnimationDuration:self.animationDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishForClose:finished:target:)];
    
    [self setX:origin.x y:origin.y width:self.width height:self.height];
    
    self.backgroundView.alpha = 0.0f;
    self.alpha = (self.animationFadeOnMove ? 0.0f : 1.0f);
    self.backgroundView.alpha = 0.0f;
    
    [UIView commitAnimations];
}

- (void)finishTranslationOnClose:(NSString *)animationId finished:(BOOL)finished target:(UIView *)target {
    [self removeFromSuperview];
    [self.backgroundView removeFromSuperview];    
    if (self.delegate) {
        [self.delegate popUpViewDismissed:self];
    }
}

- (void)finishResizeOnWidth:(NSString *)animationId finished:(BOOL)finished target:(UIView *)target {
    [UIView beginAnimations:@"2" context:self];
    [UIView setAnimationDuration:self.animationDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishForClose:finished:target:)];
    
    if ([UIView isAlignedAtLeft:self.alignment]) {
        [self setX:0 y:self.y width:5 height:5];    
    }
    
    if ([UIView isAlignedAtVerticalCenter:self.alignment]) {
        [self setX:self.superview.width / 2 y:self.y width:5 height:5];    
    }
    
    if ([UIView isAlignedAtRight:self.alignment]) {
        [self setX:self.superview.width y:self.y width:5 height:5];    
    }
    
    self.backgroundView.alpha = 0.0f;
    [UIView commitAnimations];
}

- (void)finishForClose:(NSString *)animationId finished:(BOOL)finished target:(UIView *)target {
    [self removeFromSuperview];
    [self.backgroundView removeFromSuperview];
}

- (void)commonDimiss {
    if (self.delegate) {
        [self.delegate popUpViewDismissed:self];
    }
}

- (void)dealloc {
    [self.animationTranslationView release];
    [self.backgroundView release];
    
    [self.backgroundColor release];
    [super dealloc];
}

@end
