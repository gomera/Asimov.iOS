//
//  UIAlertView_Teracode.h
//  Teracode
//
//  Created by Javier Holcman on 11/10/11.
//  Copyright (c) 2011 Teracode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIAlertView (UIAlertView_Teracode)

// Show alertview with message, title, default button title, secondary button title and delegate
+ (void)showWithMessage:(NSString *)aMessage title:(NSString *)aTitle cancelButtonTitle:(NSString *)buttonTitle otherButtonTitle:(NSString *)anOtherButtonTitle delegate:(id)aDelegate;

// Show alertview with message, title and default button title
+ (void)showWithMessage:(NSString *)aMessage title:(NSString *)aTitle cancelButtonTitle:(NSString *)buttonTitle;

// Show alertview with message and the default button title
+ (void)showWithMessage:(NSString *)aMessage cancelButtonTitle:(NSString *)buttonTitle;

// Show alertview with message
+ (void)showWithMessage:(NSString *)aMessage;

@end
