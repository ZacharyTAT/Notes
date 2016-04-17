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
#define kUid @"kUid"

@implementation ZHUser

- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password uid:(NSInteger)uid
{
    if (self = [super init]) {
        self.username = username;
        self.password = password;
        self.uid = uid;
    }
    return self;
}

+ (instancetype)userWithUsername:(NSString *)username password:(NSString *)password uid:(NSInteger)uid
{
    return [[self alloc] initWithUsername:username password:password uid:uid];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.uid = [decoder decodeIntegerForKey:kUid];
        self.username = [decoder decodeObjectForKey:kUsername];
        self.password = [decoder decodeObjectForKey:kPassword];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:self.uid forKey:kUid];
    [encoder encodeObject:self.username forKey:kUsername];
    [encoder encodeObject:self.password forKey:kPassword];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%d/%@/%@",self.uid ,self.username ,self.password];
}

@end
