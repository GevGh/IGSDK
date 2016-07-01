//
//  IGUser.h
//  InstagramSDKDemo
//
//  Created by Gevorg Ghukasyan on 2016-06-29.
//  Copyright © 2016 Gevorg Ghukasyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGUser : NSObject

+ (nullable instancetype)currentUser;

/**
 *  User's unique username.
 */
@property (nonatomic, copy, readonly, nullable) NSString *username;

/**
 *  User's full name.
 */
@property (nonatomic, copy, readonly, nullable) NSString *fullName;

@end
