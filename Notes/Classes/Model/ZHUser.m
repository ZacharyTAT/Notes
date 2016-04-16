//
//  ZHUser.m
//  Notes
//
//  Created by apple on 4/16/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHUser.h"

#define kUsername @"kUsername"
#define kPassword @"kPassword"

@implementation ZHUser

- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password
{
    if (self = [super init]) {
        self.username = username;
        self.password = password;
    }
    return self;
}

+ (instancetype)userWithUsername:(NSString *)username password:(NSString *)password
{
    return [[self alloc] initWithUsername:username password:password];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.username = [decoder decodeObjectForKey:kUsername];
        self.password = [decoder decodeObjectForKey:kPassword];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.username forKey:kUsername];
    [encoder encodeObject:self.password forKey:kPassword];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@/%@",self.username ,self.password];
}

@end
