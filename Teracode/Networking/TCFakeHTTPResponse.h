//
//  TCFakeHTTPResponse.h
//  Teracode
//
//  Created by Damian Ferrai on 6/17/10.
//  Copyright 2010 Teracode. All rights reserved.
//

@interface TCFakeHTTPResponse : NSHTTPURLResponse {
	NSMutableDictionary *mockedHeaderFields;
	NSInteger mockedStatusCode;
}

- (void)addHeaderField:(NSString*)headerField forKey:(NSString*)headerFieldKey;

@property (nonatomic, assign) NSInteger mockedStatusCode;

@end
