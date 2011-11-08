//
//  TeracodeTests.m
//  TeracodeTests
//
//  Created by Emanuel Andrada on 9/19/11.
//  Copyright 2011 Teracode. All rights reserved.
//

#import "TeracodeTests.h"


@implementation TeracodeTests

- (void)setUp {
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testSuccess {
    GHAssertTrue(true, @"Trivial test that will never fail");
}

- (void) testMock {
    id mock = [self mockForClass: [NSString class]];
    GHAssertNotNil(mock, @"Mock was not created");
    
    NSString *stubStringResponse = @"testlowercase";
    [[[mock stub] andReturn: stubStringResponse] lowercaseString];
    GHAssertEqualStrings(stubStringResponse, [mock lowercaseString], @"OCMock is not working as expected");
}

@end
