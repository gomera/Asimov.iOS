
#import "TCRequest.h"

@protocol TCNetworkManagerDelegate;

@interface TCNetworkJob : NSObject {
	NSDictionary *params;
	NSDictionary *headers;
	NSDictionary *files;
	NSURL *url;
	TCRequestMethodType method;
	TCRequest *request;
	NSTimeInterval timeout;
	id<TCNetworkManagerDelegate> delegate;
    BOOL executeImmediately;
    NSStringEncoding encoding;
    BOOL mock;
    float delay;
}

@property (nonatomic, copy) NSDictionary *params;
@property (nonatomic, copy) NSDictionary *headers;
@property (nonatomic, copy) NSDictionary *files;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, assign) TCRequestMethodType method;
@property (nonatomic, retain) TCRequest *request;
@property (nonatomic, assign) NSTimeInterval timeout;
@property (nonatomic, assign) id<TCNetworkManagerDelegate> delegate;
@property (nonatomic, assign) BOOL  executeImmediately;
@property (nonatomic, assign) NSStringEncoding encoding;
@property (nonatomic, assign) BOOL  mock;
@property (nonatomic, assign) float delay;


- (void) execute: (id<TCRequestDelegate>) requestDelegate;
- (void) cancel;

@end
