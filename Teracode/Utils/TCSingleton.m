//
//  TCSingleton.m
//  Teracode
//
//  Created by Javier Holcman on 11/10/11.
//  Copyright (c) 2011 Teracode. All rights reserved.
//

#import "TCSingleton.h"

@implementation TCSingleton

static TCSingleton *sharedInstance = nil;

- (id)init
{
    @synchronized(self) {
       [super init];
        [self initialize];
        return self;
    }
}

- (void)initialize {
    //empty implementation by default
}
	
+ (TCSingleton *)sharedInstance {
    @synchronized (self) {
        if (sharedInstance == nil) {
            [[self alloc] init];
        }
    }
    
    return sharedInstance;
}	

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
         if (sharedInstance == nil) {
             sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
       
    return nil;
}
	
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
	
- (id)retain {
    return self;
}

- (id)autorelease {
    return self;
}
	
- (NSUInteger)retainCount {
    return NSUIntegerMax; // This is sooo not zero
}
@end
