//
//  PLViewManager.m
//  Plataforma10
//
//  Created by Javier Holcman on 9/19/11.
//  Copyright 2011 Teracode. All rights reserved.
//

#import "TCLockUI.h"

static TCLockUI *_sharedInstance;

@interface TCLockUI ()

- (UIWindow *)window;
- (UIView *)createBlockViewWithFrame:(CGRect)frame;
- (UIActivityIndicatorView *)createActivityIndicatorWithFrame:(CGRect)frame;

@end

@implementation TCLockUI

@synthesize activityIndicator = _activityIndicator;
@synthesize blockView = _blockView;

+ (TCLockUI *)sharedInstance 
{
    if (_sharedInstance == nil) {
        _sharedInstance = [[TCLockUI alloc] init];
    }
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        locksCount = 0;
    }
    return self;
}

- (void)lockWindow
{
    locksCount++;
    
    if (locksCount > 1) {
        return;
    }
    
    if (self.blockView == nil) {
        self.blockView = [self createBlockViewWithFrame: [self window].frame];
    }
    else {
        self.blockView.frame = [self window].frame;
    }
    
    [[self window] addSubview:self.blockView];
}

- (void)lockWindowWithActivityIndicator 
{
    [self lockWindow];
    if (locksCount > 1) {
        return;
    }
    
    CGRect frame = CGRectMake(([self window].frame.size.width / 2) - 37/2, 
                              ([self window].frame.size.height / 2) - 37/2, 
                              37, 
                              37);
    
    if (self.activityIndicator == nil) {
        self.activityIndicator = [self createActivityIndicatorWithFrame:frame];
    } 
    else {
        self.activityIndicator.frame = frame;
    }
    
    [[self window] addSubview:self.activityIndicator];    
}

- (void)lockView:(UIView *)view
{
    locksCount ++;
    if (locksCount > 1) {
        return;
    }
    
    
    if (self.blockView == nil) {
        self.blockView = [self createBlockViewWithFrame: view.frame];
    }
    else {
        self.blockView.frame = view.frame;
    }
    
    [view addSubview:self.blockView];    
}

- (void)lockViewWithActivityIndicator:(UIView *)view
{
    [self lockView:view];
    if (locksCount > 1) {
        return;
    }
    
    CGRect frame = CGRectMake((view.frame.size.width / 2) - 37/2, 
                              (view.frame.size.height / 2) - 37/2, 
                              37, 
                              37);
    
    if (self.activityIndicator == nil) {
        self.activityIndicator = [self createActivityIndicatorWithFrame:frame];
    } 
    else {
        self.activityIndicator.frame = frame;
    }
    
    [view addSubview:self.activityIndicator];    
}

- (void)unlockWindow
{
    locksCount--;
    if (locksCount > 0) {
        return;
    }
    
    [self.blockView removeFromSuperview];
    [self.activityIndicator removeFromSuperview];
}

- (void)unlockView
{
    locksCount--;
    if (locksCount > 0) {
        return;
    }
    
    [self.blockView removeFromSuperview];
    [self.activityIndicator removeFromSuperview];
}

- (UIView *)createBlockViewWithFrame:(CGRect)frame
{
    UIView *blockView = [[[UIView alloc] initWithFrame:frame] autorelease];
    
    blockView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    blockView.backgroundColor = [UIColor blackColor];
    blockView.alpha = 0.6;    
    return blockView;
}

- (UIActivityIndicatorView *)createActivityIndicatorWithFrame:(CGRect)frame 
{
    UIActivityIndicatorView *activity = [[[UIActivityIndicatorView alloc] initWithFrame:frame] autorelease];
    [activity startAnimating];
    return activity;
}

- (UIWindow *)window 
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return window;
}

- (void)dealloc 
{
    // will never be called
    [super dealloc];
}

@end
