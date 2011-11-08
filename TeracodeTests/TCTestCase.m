//
//  TCTestCase.m
//  Teracode
//
//  Created by Diego Sebastian Mera on 11/7/11.
//  Copyright 2011 Teracode. All rights reserved.
//

#import "TCTestCase.h"


@implementation TCTestCase

- (id) mockForClass: (Class) clazz {
    return [OCMockObject mockForClass: clazz];
}

@end
