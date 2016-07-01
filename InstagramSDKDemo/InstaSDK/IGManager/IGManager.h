//
//  IGManager.h
//  InstagramSDKDemo
//
//  Created by Gevorg Ghukasyan on 2016-06-29.
//  Copyright © 2016 Gevorg Ghukasyan. All rights reserved.
//

#import "IGBaseService.h"

@interface IGManager : IGBaseService

+ (instancetype)sharedManager;

- (void)loginUserWithUsername:(NSString *)username
                     password:(NSString *)password
                   completion:(IGResponseBlock )completion;

/**
 *  Requests timeout.
 *  Defoult is 20.0
 */
@property (nonatomic) NSTimeInterval requestTimeout;

@end
