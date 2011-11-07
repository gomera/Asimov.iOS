#import "TCAttachment.h"


@implementation TCAttachment

@synthesize mime;
@synthesize filename;
@synthesize data;

- (void) dealloc {
	[mime release];
	[filename release];
	[data release];
	[super dealloc];
}


@end
