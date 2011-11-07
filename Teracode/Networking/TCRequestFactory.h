@class TCRequest;
@class TCNetworkJob;
@protocol TCRequestDelegate;

@interface TCRequestFactory : NSObject {

}

+ (TCRequest *) newRequestWithDelegate: (id<TCRequestDelegate>) delegate job: (TCNetworkJob *) job;

@end
