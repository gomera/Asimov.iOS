//
//  TCTestCase.h
//  Teracode
//
//  Created by Diego Sebastian Mera on 11/7/11.
//  Copyright 2011 Teracode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>
#import <OCMock/OCMock.h>


@interface TCTestCase : GHTestCase {
    
}

- (id) mockForClass: (Class) clazz;

@end
