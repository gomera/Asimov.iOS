//
//  TCServerCRUDAPICall.h
//  Teracode
//
//  Created by Damian Ferrai on 12/27/10.
//  Copyright 2010 Teracode. All rights reserved.
//

#import "TCFetchAPICall.h"

// API Call type enum
typedef enum {
	TCAPICallTypeCreate = 0,
	TCAPICallTypeRead,
	TCAPICallTypeUpdate,
	TCAPICallTypeDelete
} TCAPICallType;


//
// Handles CRUD (Create, Read, Update, Delete) API calls
//
@interface TCServerCRUDAPICall : TCFetchAPICall {
	TCAPICallType type;
}

@property (nonatomic, assign) TCAPICallType type;

@end
