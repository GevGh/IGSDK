//
//  IGManager.m
//  InstagramSDKDemo
//
//  Created by Gevorg Ghukasyan on 2016-06-29.
//  Copyright © 2016 Gevorg Ghukasyan. All rights reserved.
//

#import "IGManager.h"

@interface IGManager ()

@end

@implementation IGManager

+ (instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    static IGManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[IGManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.requestTimeout = 20.0;
    }
    return self;
}

- (void)loginUserWithUsername:(NSString *)username
                     password:(NSString *)password
                   completion:(IGResponseBlock )completion {
    
    [super syncInstagram:^(NSDictionary *serverResponse, NSError *error) {
        
        if (!error) {
            
            [super makeFullyPostRequest:kLoginEndpoint
                             withParams:@{@"password" : password,
                                          @"username" : username
                                          }
                             completion:completion];
        } else {
            
            NSLog(@"error :: %@", error);
        }
    }];
}

@end
