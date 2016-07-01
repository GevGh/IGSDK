//
//  IGBaseService.h
//  InstagramSDKDemo
//
//  Created by Gevorg Ghukasyan on 2016-06-29.
//  Copyright © 2016 Gevorg Ghukasyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGConstants.h"

typedef void (^IGResponseBlock)(NSDictionary *serverResponse, NSError *error);

@interface IGBaseService : NSObject

- (void)syncInstagram:(IGResponseBlock)completion;

- (void)makeFullyPostRequest:(NSString *)url
                  withParams:(NSDictionary*)params
                  completion:(IGResponseBlock)completion;

- (void)makeFullyGetRequest:(NSString *)url
                 withParams:(NSDictionary*)params
                 completion:(IGResponseBlock)completion;

@end
