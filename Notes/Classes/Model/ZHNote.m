//
//  ZHNote.m
//  Notes
//
//  Created by apple on 12/1/15.
//  Copyright (c) 2015 swjtu. All rights reserved.
//

#import "ZHNote.h"

#define kNoteId @"NoteId"
#define kTitle @"title"
#define kModifydate @"modifydate"
#define kContent @"content"


@interface ZHNote()<NSCoding>

@end

@implementation ZHNote

#pragma mark - constructor
- (instancetype)initWithTitle:(NSString *)title modifydate:(NSDate *)modifydate content:(NSString *)content;
{
    if (self = [super init]) {
        self.title = title;
        self.modifydate = modifydate;
        self.content = content;
    }
    
    return self;
}
+ (instancetype)noteWithTitle:(NSString *)title modifydate:(NSDate *)modifydate content:(NSString *)content
{
    return [[self alloc] initWithTitle:title modifydate:modifydate content:content];
}
#pragma mark - coding

#pragma mark - decode
- (instancetype)initWithCoder:(NSCoder *)decode
{
    NSInteger noteId = [decode decodeIntegerForKey:kNoteId];
    NSString *title = [decode decodeObjectForKey:kTitle];
    NSDate *modifydate = [decode decodeObjectForKey:kModifydate];
    NSString *content = [decode decodeObjectForKey:kContent];
    
//    return [self initWithId:noteId Title:title modifydate:modifydate content:content];
    self = [self initWithTitle:title modifydate:modifydate content:content];
    self.noteId = noteId;
    return self;
}

#pragma mark - encode
- (void)encodeWithCoder:(NSCoder *)encode
{
    [encode encodeInteger:_noteId forKey:kNoteId];
    [encode encodeObject:_title forKey:kTitle];
    [encode encodeObject:_modifydate forKey:kModifydate];
    [encode encodeObject:_content forKey:kContent];
}


#pragma mark - description
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@\n{noteId:%d,\n\ntitle:%@,\nmodifydate:%@,\ncontent:%@,\naddr:%p\n}",[self class],self.noteId,self.title,self.modifydate,self.content,self];
}




@end









