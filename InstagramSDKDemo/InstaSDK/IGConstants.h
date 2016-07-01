//
//  IGConstants.h
//  InstagramSDKDemo
//
//  Created by Gevorg Ghukasyan on 2016-06-29.
//  Copyright © 2016 Gevorg Ghukasyan. All rights reserved.
//

#ifndef IGConstants_h
#define IGConstants_h


typedef NS_ENUM (NSInteger, IGRequestType) {
    IGRequestTypePost = 1,
    IGRequestTypeGet,
};

//NSUserDefoults keys

static NSString *const kUserDefoultCSRFtoken = @"kUserDefoultCSRFtoken";


//base url
static NSString *const kBaseServerUrl = @"https://i.instagram.com/api/v1/%@";

//endpoints
static NSString *const kLoginEndpoint = @"accounts/login/";
static NSString *const kSyncEndpoint = @"qe/sync/";


#endif /* IGConstants_h */
