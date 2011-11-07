
@interface TCAttachment : NSObject {
	NSString *mime;
	NSString *filename;
	NSData *data;
}

@property (nonatomic, retain) NSString *mime;
@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) NSData *data;

@end
