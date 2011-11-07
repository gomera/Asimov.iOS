
#import "TCAPICall.h"

/**
 * This is a subclass of the APICall class that adds functionality to process responses, 
 * saving the result as an object in a property. The response data is interpreted as 
 * a JSON document, and converted to Objective-C objects in memory using a parser that 
 * leaves the same structure that the document had but using NSArrays, NSDictionaries, 
 * NSNumbers, and so on.
 * 
 * If an error occurrs when trying to parse the response data, the delegate will be sent 
 * the "apiCall:didFinishWithError:" message with a description of the problem.
 */
@interface TCFetchAPICall : TCAPICall {
	id responseData;
    NSMutableDictionary *userInfo;
}

// This is valid only after the delegate has been notified with "apiCallDidFinishSuccessfully:"
@property (nonatomic, retain) id responseData;

// Additional info
@property (nonatomic, retain) NSMutableDictionary *userInfo;

+ (Class)parserClass;

@end
