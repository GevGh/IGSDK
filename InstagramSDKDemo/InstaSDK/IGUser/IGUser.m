//
//  IGUser.m
//  InstagramSDKDemo
//
//  Created by Gevorg Ghukasyan on 2016-06-29.
//  Copyright © 2016 Gevorg Ghukasyan. All rights reserved.
//

#import "IGUser.h"

@interface IGUser () <NSCopying, NSSecureCoding, NSObject>

@end

@implementation IGUser

+ (instancetype)currentUser {
    
    return [[[self class] alloc] init];
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        
        _username = [coder decodeObjectOfClass:[NSString class] forKey:@"username"];
        _fullName = [coder decodeObjectOfClass:[NSString class] forKey:@"fullName"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.fullName forKey:@"fullName"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    IGUser *copy = [[self class] allocWithZone:zone];
    copy->_username = [self.username copy];
    copy->_fullName = [self.fullName copy];
    return copy;
}

@end
