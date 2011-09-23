//
//  TCAppDelegate.h
//  Teracode
//
//  Created by Diego Sebastian Mera on 1/7/10.
//  Copyright 2010 TeraCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TCAppDelegate :  NSObject<UIApplicationDelegate> {
    
    // For SwitchViews category
    @private
    UIViewController *switchViewController;
    UIViewController *currentViewController;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) UIViewController *currentViewController;
@property (nonatomic, retain) UIViewController *switchViewController;


@end

typedef enum {
	TCSwitchViewAnimationTypeNone,
	TCSwitchViewAnimationTypeRightToLeft,
	TCSwitchViewAnimationTypeLeftToRight
} TCSwitchViewAnimationType;


@interface TCAppDelegate (SwitchViews)

- (void) switchViewController: (UIViewController *) viewController animationType: (TCSwitchViewAnimationType) animationType;    

@end
