
@protocol TCParser <NSObject>

- (id) parse: (NSData *) data encoding: (NSStringEncoding) encoding error: (NSError **) error;

@end
