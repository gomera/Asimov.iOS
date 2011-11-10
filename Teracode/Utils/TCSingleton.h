//
//  TCSingleton.h
//  Teracode
//
//  Created by Javier Holcman on 11/10/11.
//  Copyright (c) 2011 Teracode. All rights reserved.
//

//  To make singletons, inherit TCSingleton and override the sharedInstance method
//  to return the correct type and the definition on the interface. Example:
//
//      Implementation
//      + (TCTest *)sharedInstance {
//          return (TCTest *)[super sharedInstance];
//      }
//
//      Interface
//      + (TCTest *)sharedInstance;
//

@interface TCSingleton : NSObject

+ (TCSingleton *)sharedInstance;

- (void)initialize;

@end
