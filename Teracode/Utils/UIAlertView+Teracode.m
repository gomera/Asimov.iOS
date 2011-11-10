//
//  UIAlertView_Teracode.m
//  Teracode
//
//  Created by Javier Holcman on 11/10/11.
//  Copyright (c) 2011 Teracode. All rights reserved.
//

#import "UIAlertView+Teracode.h"

@implementation UIAlertView (UIAlertView_Teracode)

// Show alertview with message, title, default button title, secondary button title and delegate
+ (void)showWithMessage:(NSString *)aMessage 
				  title:(NSString *)aTitle 
	  cancelButtonTitle:(NSString *)buttonTitle 
       otherButtonTitle:(NSString *)anOtherButtonTitle
			   delegate:(id)aDelegate 
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:aTitle
													  message:aMessage
													 delegate:aDelegate
											cancelButtonTitle:buttonTitle
											otherButtonTitles:anOtherButtonTitle, nil];
	[message show];
    [message release];
    
}

// Show alertview with message, title and default button title
+ (void)showWithMessage:(NSString *)aMessage title:(NSString *)aTitle cancelButtonTitle:(NSString *)buttonTitle 
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:aTitle
													  message:aMessage
													 delegate:nil
											cancelButtonTitle:buttonTitle
											otherButtonTitles:nil];
    [message show];
    [message release];
}

// Show alertview with message and the default button title
+ (void)showWithMessage:(NSString *)aMessage cancelButtonTitle:(NSString *)buttonTitle 
{
	[UIAlertView showWithMessage:aMessage title:@"" cancelButtonTitle:buttonTitle];
}

// Show alertview with message
+ (void)showWithMessage:(NSString *)aMessage 
{
	[UIAlertView showWithMessage:aMessage title:@"" cancelButtonTitle:@"OK"];	
}

@end
