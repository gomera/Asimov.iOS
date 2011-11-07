
#import "TCFakeHTTPResponse.h"

@interface TCFakeHTTPResponse ()
@property (nonatomic, retain) NSMutableDictionary *mockedHeaderFields;
@end


@implementation TCFakeHTTPResponse

@synthesize mockedHeaderFields;
@synthesize mockedStatusCode;

- (NSDictionary *)allHeaderFields {
	return self.mockedHeaderFields;
}

- (void)addHeaderField:(NSString*)headerField forKey:(NSString*)headerFieldKey {
	[self.mockedHeaderFields setObject:headerField forKey:headerFieldKey];
}

- (NSInteger)statusCode {
	return mockedStatusCode;
}

- (void)dealloc {
	[mockedHeaderFields release];
	[super dealloc];
}

#pragma mark Custom properties

- (NSDictionary*)mockedHeaderFields {
	if (!mockedHeaderFields) {
		mockedHeaderFields = [[NSMutableDictionary alloc] init];
	}
	return mockedHeaderFields;
}

@end
