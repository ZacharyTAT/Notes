//
//  ZHNote.m
//  Notes
//
//  Created by apple on 12/1/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import "ZHNote.h"

#define kTitle @"title"
#define kModifydate @"modifydate"
#define kContent @"content"


@interface ZHNote()<NSCoding>

@end

@implementation ZHNote

#pragma mark - constructor
- (instancetype)initWithTitle:(NSString *)title modifydate:(NSDate *)modifydate content:(NSString *)content
{
    if (self = [super init]) {
        self.title = title;
        self.modifydate = modifydate;
        self.content = content;
    }
    
    return self;
}

#pragma mark - coding

#pragma mark - decode
- (instancetype)initWithCoder:(NSCoder *)decode
{
    NSString *title = [decode decodeObjectForKey:kTitle];
    NSDate *modifydate = [decode decodeObjectForKey:kModifydate];
    NSString *content = [decode decodeObjectForKey:kContent];
    
    return [self initWithTitle:title modifydate:modifydate content:content];
}

#pragma mark - encode
- (void)encodeWithCoder:(NSCoder *)encode
{
    [encode encodeObject:_title forKey:kTitle];
    [encode encodeObject:_modifydate forKey:kModifydate];
    [encode encodeObject:_content forKey:kContent];
}


#pragma mark - description
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@\n{\ntitle:%@,\nmodifydate:%@,\ncontent:%@,\naddr:%p\n}",NSStringFromClass([self class]),self.title,self.modifydate,self.content,self];
}




@end









