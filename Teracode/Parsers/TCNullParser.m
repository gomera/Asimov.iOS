//
//  TCNullParser.m
//  Teracode
//
//  Created by Diego Sebastian Mera on 11/4/11.
//  Copyright 2011 Teracode. All rights reserved.
//

#import "TCNullParser.h"


@implementation TCNullParser

- (id) parse: (NSData *) data encoding: (NSStringEncoding) encoding error: (NSError **) error {
    return data;
}

@end
