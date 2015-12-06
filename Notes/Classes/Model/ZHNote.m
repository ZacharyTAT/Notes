//
//  ZHNote.m
//  Notes
//
//  Created by apple on 12/1/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import "ZHNote.h"

@implementation ZHNote

- (instancetype)initWithTitle:(NSString *)title modifydate:(NSDate *)modifydate content:(NSString *)content
{
    if (self = [super init]) {
        self.title = title;
        self.modifydate = modifydate;
        self.content = content;
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@\n{\ntitle:%@,\nmodifydate:%@,\ncontent:%@,\naddr:%p\n}",NSStringFromClass([self class]),self.title,self.modifydate,self.content,self];
}

@end
