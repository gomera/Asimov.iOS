//
//  TCLockUI.h
//  Teracode
//
//  Created by Javier Holcman on 9/19/11.
//  Copyright 2011 Teracode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCLockUI : NSObject {
    UIView *_blockView;
    UIActivityIndicatorView *_activityIndicator;
    int locksCount;
}

@property (nonatomic, retain) UIView *blockView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

+ (TCLockUI *)sharedInstance;

- (void)lockWindow;
- (void)lockWindowWithActivityIndicator;
- (void)lockView:(UIView *)view;
- (void)lockViewWithActivityIndicator:(UIView *)view;

- (void)unlockWindow;
- (void)unlockView;

@end
