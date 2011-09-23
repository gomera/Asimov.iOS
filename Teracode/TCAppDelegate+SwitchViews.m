//
//  TCAppDelegate+SwitchViews.m
//  Teracode
//
//  Created by Diego Sebastian Mera on 1/7/10.
//  Copyright 2010 TeraCode. All rights reserved.
//

#import "TCAppDelegate.h"

@interface TCAppDelegate (SwitchViewsPrivate)

- (void) viewSwitchingAnimationDidStop: (NSString *) animationID finished: (NSNumber *) finished context: (void *) context;

@end

@implementation TCAppDelegate (SwitchViewsPrivate)

- (void) viewSwitchingAnimationDidStop: (NSString *) animationID finished: (NSNumber *) finished context: (void *) context {
    
	// Remove the old view from the window
	[self.currentViewController.view removeFromSuperview];
	
	// Replace the current view controller by the new one
	self.currentViewController = self.switchViewController;
	self.switchViewController = nil;
}

@end


@implementation TCAppDelegate (SwitchViews)

- (void) switchViewController: (UIViewController *) viewController animationType: (TCSwitchViewAnimationType) animationType {
    viewController.view.transform = CGAffineTransformIdentity;
    viewController.view.frame = [[UIScreen mainScreen] applicationFrame];
    
    if (animationType == TCSwitchViewAnimationTypeNone) {
		// Remove previous view from the window
		[self.currentViewController.view removeFromSuperview];
		// Replace the current view controller by the new one
		self.currentViewController = viewController;
		// Add the new view to the window
		[self.window addSubview: self.currentViewController.view];
	}
	else {
		// Save the entering view controller
		self.switchViewController = viewController;
		
		UIView* oldView = self.currentViewController.view; // Appearing from right
		UIView* newView = self.switchViewController.view; // Dissapearing to right
		
		// Position the new view outside the window, ready to be "drilled down"
		CGFloat newViewStartingX = self.window.frame.size.width * ((animationType == TCSwitchViewAnimationTypeRightToLeft) ? 1 : -1);
		newView.transform = CGAffineTransformMakeTranslation(newViewStartingX, 0);
		
		// Add the new view to the window
		[self.window addSubview: newView];
		
		// Prepare the animations, passing the old view as the context (in order to remove it when the animation ends)
		[UIView beginAnimations: @"WindowViewSwitching" context: nil];
		[UIView setAnimationDelegate: self];
		[UIView setAnimationDuration: 0.3f];
		[UIView setAnimationDidStopSelector: @selector(viewSwitchingAnimationDidStop:finished:context:)];
		
		// Make the "drill down" effect, positioning the new view inside the window, and the old view outside (on left)
		CGFloat oldViewEndingX = self.window.frame.size.width * ((animationType == TCSwitchViewAnimationTypeRightToLeft) ? -1 : 1);
		oldView.transform = CGAffineTransformMakeTranslation(oldViewEndingX, 0);
		newView.transform = CGAffineTransformIdentity;
		
		// Start animation
		[UIView commitAnimations];
	}
    
}

@end
