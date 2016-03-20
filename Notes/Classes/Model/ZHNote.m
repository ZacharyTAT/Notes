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
#define kStick @"stick"
#define kLock @"lock"

@interface ZHNote()<NSCoding>

@end

@implementation ZHNote

#pragma mark - constructor
- (instancetype)initWithTitle:(NSString *)title modifydate:(NSDate *)modifydate content:(NSString *)content stick:(BOOL)stick lock:(BOOL)lock;
{
    if (self = [super init]) {
        self.title = title;
        self.modifydate = modifydate;
        self.content = content;
        self.stick = stick;
        self.lock = lock;
    }
    
    return self;
}
+ (instancetype)noteWithTitle:(NSString *)title modifydate:(NSDate *)modifydate content:(NSString *)content stick:(BOOL)stick lock:(BOOL)lock
{
    return [[self alloc] initWithTitle:title modifydate:modifydate content:content stick:stick lock:lock];
}
#pragma mark - coding

#pragma mark - decode
- (instancetype)initWithCoder:(NSCoder *)decode
{
    NSInteger noteId = [decode decodeIntegerForKey:kNoteId];
    NSString *title = [decode decodeObjectForKey:kTitle];
    NSDate *modifydate = [decode decodeObjectForKey:kModifydate];
    NSString *content = [decode decodeObjectForKey:kContent];
    BOOL stick = [decode decodeBoolForKey:kStick];
    BOOL lock = [decode decodeBoolForKey:kLock];
    
//    return [self initWithId:noteId Title:title modifydate:modifydate content:content];
    self = [self initWithTitle:title modifydate:modifydate content:content stick:stick lock:lock];
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
    [encode encodeBool:_stick forKey:kStick];
    [encode encodeBool:_lock forKey:kLock];
}


#pragma mark - description
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@\n{noteId:%d,\n\ntitle:%@,\nmodifydate:%@,\ncontent:%@,\nstick:%d,\nlock:%d,\naddr:%p\n}",[self class],self.noteId,self.title,self.modifydate,self.content,self.stick,self.lock,self];
}




@end









