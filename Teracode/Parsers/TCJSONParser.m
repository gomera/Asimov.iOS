#import "TCJSONParser.h"
#import "JSON/JSON.h"

@implementation TCJSONParser

- (id) parse: (NSData *) data encoding: (NSStringEncoding) encoding error: (NSError **) error {
	
	NSString *json = [[NSString alloc] initWithData: data encoding: encoding];
	TCSBJSON *parser = [[TCSBJSON alloc] init];
	
	id response = [parser objectWithString: json error: error];
	
	[json release];
	[parser release];
	
	return response;
}

@end
